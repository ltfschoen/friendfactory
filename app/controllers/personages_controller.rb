class PersonagesController < ApplicationController

  extend ActiveSupport::Memoizable

  before_filter :require_user
  before_filter :require_admin, :only => [ :new, :create ]

  helper_method \
      :personage,
      :invitation_wave,
      :paged_users,
      :page_title

  layout 'personage'

  cattr_reader :per_page
  @@per_page = 48

  def index
    @users = users.order('`postings`.`updated_at` DESC').scoped
    respond_to do |format|
      format.html { render :layout => 'rollcall' }
    end
  end

  def online
    @users = users.joins(:user).merge(User.online).merge(User.order_by_most_recent_request).scoped
    respond_to do |format|
      format.html { render 'index', :layout => 'rollcall' }
    end
  end

  def show
    @personage = params[:id].present? ?
        current_user_record.personages.find(params[:id]) :
        current_user
    respond_to do |format|
      format.html
    end
  end

  def new
    @personage = current_user_record.personages.build(default_attributes)
    respond_to do |format|
      format.html
    end
  end

  def create
    state = params[:personage].delete(:state)
    @personage = current_user_record.personages.build(params[:personage])
    @personage.state = state
    respond_to do |format|
      if @personage.save
        @personage.publish_avatar_to_profile_wave
        session[:personage_id] = @personage.id
        format.html { redirect_to profile_path(@personage) }
      else
        format.html { render :action => 'new' }
      end
    end
  end

  def edit
    @personage = params[:id].present? ?
        current_user_record.personages.find(params[:id]) :
        current_user
    respond_to do |format|
      format.html
    end
  end

  def update
    @personage = current_user_record.personages.find(params[:id])
    respond_to do |format|
      if personage.update_attributes(params[:personage])
        current_site.home_wave.postings << new_persona_posting
        new_persona_posting.publish!
        format.html { redirect_to profile_path }
        format.json { render :json => { :ok => true }}
      else
        format.html { render :action => 'edit' }
        format.json { render :json => { :ok => false }}
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
    respond_to do |format|
      avatar = if params[:id] && personage = current_user_record.personages.find_by_id(params[:id])
        pid = "pid-#{personage[:id]}"
        handle = personage.handle
        personage.create_and_publish_avatar_to_profile_wave(params[:posting_avatar])
      else
        handle = current_user.handle
        Posting::Avatar.create(params[:posting_avatar]) do |posting|
          posting.user = current_user
          posting.site = current_site
        end
      end
      format.json { render :json => { :url => avatar.url(:polaroid), :title => handle, :pid => pid, :avatar_id => avatar[:id] }, :content_type => 'text/html' }
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
    @paged_users ||= begin
      users.paginate(:page => params[:page], :per_page => @@per_page)
    end
  end

  def users
    @users ||= begin
      users = Personage.enabled.site(current_site).scoped
      users = users.type(params[:persona_type].singularize).scoped if params[:persona_type]
      users.includes(:persona => :avatar).includes(:profile).scoped
    end
  end

  def new_persona_posting
    @new_persona_posting ||= begin
      Posting::Persona.new do |posting|
        posting.user = current_user
      end
    end
  end

  def page_title
    "title"
    # if title = @page_title || personage.handle
    #   title.titleize
    # end
    # [ current_site.display_name, title ].join(' - ')
  end

  def invitation_wave
    current_user.find_or_create_invitation_wave_for_site(current_site)
  end

  memoize :page_title

  ###

  def transaction
    ActiveRecord::Base.transaction { yield }
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def default_attributes
    type = params[:type] || 'person'
    { :persona_attributes => { :type => "Persona::#{type.titleize}", :emailable => true }}
  end

end