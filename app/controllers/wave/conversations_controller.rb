class Wave::ConversationsController < ApplicationController

  before_filter :require_user
  helper_method :page_title, :conversations, :profiles, :profiles_by_user_id, :tags

  layout 'wave/conversation'

  cattr_reader :per_page
  @@per_page = 12

  def index
    respond_to do |format|
      format.html
    end
  end

  def show
    # Conversation with other user identified by :profile_id
    user = Wave::Profile.find_by_id(params[:profile_id]).try(:user)
    @wave = current_user.conversation.with(user, current_site) || current_user.create_conversation_with(user, current_site)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def popup
    @popup = true
    @title = current_site.name
    @wave = current_user.conversations.site(current_site).find_by_id(params[:id])
    if @wave.present? && @wave.recipient.present?
      @title += " with #{@wave.recipient.handle(current_site)}"
    end
    respond_to do |format|
      format.html { render :action => 'show' }
    end
  end

  def close
    if @wave = current_user.inbox(current_site).find_by_id(params[:id])
      @wave.read && @wave.unpublish!
    end
    respond_to do |format|
      format.json { render :json => { :closed => true }}
    end
  end

  private

  def page_title
    "#{current_site.display_name} - #{current_profile.handle}'s Inbox"
  end

  def conversation_dates
    @conversation_dates ||=
      current_user.inbox(current_site).
          select('date(`waves`.`updated_at`) AS updated_at, count(*) AS count, group_concat(distinct resource_id) AS user_ids').
          group('date(`waves`.`updated_at`)').
          order('date(`waves`.`updated_at`) DESC')
  end

  def conversations
    @conversations ||= begin
      conversations = current_user.inbox(current_site)
          .select('`waves`.`id`, `waves`.`resource_id` AS recipient_id')
          .order('`waves`.`updated_at` DESC')

      if params[:tag].present?
        conversations.all
      else
        conversations.paginate(:page => params[:page], :per_page => @@per_page)
      end
    end
  end

  def profiles
    @profiles ||= begin
      profiles = current_site.waves.type(Wave::Profile).where(:user_id => conversations.map(&:recipient_id)).scoped
      if params[:tag].present?
        profiles.tagged_with(scrub_tag(params[:tag]), :on => current_site).paginate(:page => params[:page], :per_page => @@per_page)
      else
        profiles.all
      end
    end
  end

  def profiles_by_user_id
    @profiles_by_user_id ||= profiles.index_by(&:user_id)
  end

  def tags
    @tags ||= begin
      user_ids = current_user.inbox(current_site).select('`resource_id`').map(&:resource_id)
      profiles = current_site.waves.type(Wave::Profile).where(:user_id => user_ids)
      profiles.tag_counts_on(current_site).order('name asc').select{ |tag| tag.count > 1 }
    end
  end

  def scrub_tag(tag)
    tag.downcase.gsub(/-/, ' ')
  end

end