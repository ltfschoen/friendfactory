class PersonagesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user

  helper_method \
      :personage,
      :invitation_wave,
      :paged_users,
      :page_title

  layout 'personage'

  cattr_reader :per_page

  def index
    @@per_page = 48
    @page_title = params[:persona_type].pluralize
    respond_to do |format|
      format.html { render :layout => 'three-column' }
    end
  end

  def show
    @personage = params[:id] && current_user_record.personages.find(params[:id]) || current_user
    respond_to do |format|
      format.html
    end
  end

  def new
    attrs = { :persona_attributes => { :type => params[:type] }}
    @personage = current_user_record.personages.build(attrs)
    @personage.save(:validate => false)
    @page_title = "New #{params[:type]}"
    respond_to do |format|
      format.html { render :action => 'edit' }
    end
  end

  def edit
    @personage = params[:id] && current_user_record.personages.find(params[:id]) || current_user
    respond_to do |format|
      format.html
    end
  end

  def update
    @personage = current_user_record.personages.find(params[:id])
    respond_to do |format|
      if personage.update_attributes(params[:personage])
        personage.enable! unless personage.enabled?
        format.html { redirect_to profile_path }
        format.json { render :json => { :ok => true }}
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  def switch
    @personage = current_user_session.record.personages.find(params[:id])
    session[:personage_id] = @personage.id
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def avatar
    transaction do
      @personage = current_user_record.personages.find(params[:id])
      @posting = Posting::Avatar.new(params[:posting_avatar]) { |posting| posting.user = @personage }
      if @personage.update_attribute(:avatar, @posting)
        @personage.enable unless @personage.enabled?
        @personage.profile.postings << @posting
        @posting.publish!
      end
    end
    respond_to do |format|
      format.html { redirect_to profile_path }
      format.json { render :json => { :url => @posting.url(:polaroid), :title => current_profile.handle, :pid => "pid-#{@personage.id}" }, :content_type => 'text/html' }
    end
  end

  def unsubscribe
    current_user.update_attributes(params[:user])
    respond_to do |format|
      format.js { head :ok }
    end
  end
  
  def enable
    respond_to do |format|
      begin
        personage = current_user_record.personages.find(params[:id])
        personage.send(params[:personage][:state].to_sym)
        format.json { render :json => { :state => personage.current_state }}
      rescue => exception
        format.json { render :json => { :state => false, :exception => { :class => exception.class.to_s, :message => exception.message }}}
      end
    end
  end

  ### Panes

  def biometrics
    respond_to do |format|
      if personage
        format.html { render :layout => false }
      else
        format.html { render :nothing => true }
      end
    end
  end

  def conversation
    respond_to do |format|
      if @wave = current_user.find_or_create_conversation_with(personage, current_site).mark_as_read
        format.html { render :layout => false }
      else
        format.html { render :nothing => true }
      end
    end
  end

  def invitations
    respond_to do |format|
      if personage
        @invitations = personage.profile.postings.type(Posting::Invitation).order('`postings`.`created_at` DESC').limit(Wave::InvitationsHelper::MaximumDefaultImages)
        format.html { render :layout => false }
      else
        format.html { render :nothing => true }
      end
    end
  end

  def photos
    respond_to do |format|
      if personage(:include => :profile)
        @photos = personage.profile.photos.limit(Wave::InvitationsHelper::MaximumDefaultImages)
        format.html { render :layout => false }
      else
        format.html { render :nothing => true }
      end
    end
  end

  def map
    respond_to do |format|
      if personage
        format.html { render :layout => false }
      else
        format.html { render :nothing => true }
      end
    end
  end

  private

  def personage(opts = {})
    @personage ||= begin
      relation = Personage.enabled.site(current_site).includes(:persona).scoped
      if includes = opts.delete(:include)
        relation = relation.includes(includes).scoped
      end
      relation.find(params[:id])
    end
  end

  def paged_users
    users.paginate(:page => params[:page], :per_page => @@per_page)
  end

  memoize :paged_users

  def users
    Personage.enabled.
      site(current_site).
      type(params[:persona_type].singularize).
      includes(:persona => :avatar).
      includes(:profile).
      order('`waves`.`updated_at` DESC').
      scoped
  end

  memoize :users

  def transaction
    ActiveRecord::Base.transaction { yield }
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def page_title
    if title = @page_title || personage.handle
      title.titleize
    end
    [ current_site.display_name, title ].join(' - ')
  end

  memoize :page_title

  def invitation_wave
    current_user.find_or_create_invitation_wave_for_site(current_site)
  end

end