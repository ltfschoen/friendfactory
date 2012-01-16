class PersonagesController < ApplicationController

  before_filter :require_user

  helper_method :page_title, :invitation_wave

  layout 'personage'

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
      if @personage.update_attributes(params[:personage])
        @personage.enable! unless @personage.enabled?
        # TODO
        # @personage.profile.set_tag_list_on!(current_site)
        format.html { redirect_to profile_path }
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  def switch
    if @personage = current_user_session.record.personages.find_by_id(params[:id])
      session[:personage_id] = @personage.id
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

  def avatar
    transaction do
      @personage = current_user_record.personages.find(params[:id])
      @posting = Posting::Avatar.new(params[:posting_avatar]) { |posting| posting.user = @personage }
      if @personage.update_attribute(:avatar, @posting)
        @personage.enable if @personage.disabled?
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

  private

  def transaction
    ActiveRecord::Base.transaction { yield }
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def page_title
    "#{current_site.display_name} - #{@personage.handle}'s Profile"
  end

  def invitation_wave
    current_user.find_or_create_invitation_wave_for_site(current_site)
  end

end