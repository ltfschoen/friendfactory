class Wave::ConversationsController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method :paged_conversations, :tags
  helper_method :page_title

  layout 'inbox'

  cattr_reader :per_page
  @@per_page = 12

  def index
    respond_to do |format|
      format.html
    end
  end

  # def popup
  #   @popup = true
  #   @title = current_site.name
  #   @wave = current_user.conversations.site(current_site).find_by_id(params[:id])
  #   if @wave.present? && @wave.recipient.present?
  #     @title += " with #{@wave.recipient.handle}"
  #   end
  #   respond_to do |format|
  #     format.html { render :action => 'show' }
  #   end
  # end

  def close
    @wave = current_user.inbox(current_site).find(params[:id])
    respond_to do |format|
      @wave.read && @wave.unpublish!
      format.json { render :json => { :closed => true }}
    end
  end

  private

  def paged_conversations
    conversations.paginate(:page => params[:page], :per_page => @@per_page)
  end

  def tags
    personas.tag_counts.order('`name` ASC').select{ |tag| tag.count > 1 }
  end

  memoize :paged_conversations, :tags

  ###

  def conversations
    conversations = params[:tag] ? conversations_from_tagged_personas : conversations_from_all
    conversations.
        includes(:recipient => { :persona => :avatar }).
        order('`postings`.`updated_at` DESC').scoped
  end

  def conversations_from_all
    conversations = current_user.inbox(current_site).
        joins(:recipient).
        merge(Personage.enabled).scoped
  end

  memoize :conversations_from_all

  def conversations_from_tagged_personas
    conversations_from_all.where(:resource_id => tagged_personas.map(&:id)).scoped
  end

  def tagged_personas
    tagged_personas = personas
    tagged_personas = personas.tagged_with(parameterize_tag(params[:tag]), :on => :tags).scoped if params[:tag]
    tagged_personas
  end

  def personas
    user_ids = conversations_from_all.map(&:resource_id)
    Persona::Base.joins(:user).where(:personages => { :id => user_ids }).scoped
  end

  def conversation_dates
    current_user.inbox(current_site).
        select('date(`postings`.`updated_at`) AS updated_at, count(*) AS count, group_concat(distinct resource_id) AS recipient_ids').
        group('date(`postings`.`updated_at`)').
        order('date(`postings`.`updated_at`) DESC')
  end

  def parameterize_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

  def page_title
    "#{current_site.display_name} - #{current_profile.handle}'s Inbox"
  end

end