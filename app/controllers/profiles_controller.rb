class ProfilesController < ApplicationController

  before_filter :require_user
  helper_method :page_title, :invitation_wave

  layout 'profile'

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if current_persona.update_attributes(params[:person])
      # TODO Person should be tagged, not profile
      # TODO Move to after_create on person
      current_profile.set_tag_list_on!(current_site)
    end
    respond_to do |format|
      format.html { redirect_to profile_path }
    end
  end

  def avatar
    transaction do
      @posting = Posting::Avatar.new(params[:posting_avatar]) { |posting| posting.user = current_user }
      current_user.update_attribute(:avatar, @posting)
      current_profile.postings << @posting
      @posting.publish!
    end
    respond_to do |format|
      format.html { redirect_to profile_path }
      format.json { render :json => { :url => @posting.url(:polaroid), :title => current_profile.handle }, :content_type => 'text/html' }
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
    "#{current_site.display_name} - #{current_user.handle}'s Profile"
  end

  def invitation_wave
    current_user.find_or_create_invitation_wave_for_site(current_site)
  end

end
