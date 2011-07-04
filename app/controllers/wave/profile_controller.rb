class Wave::ProfileController < ApplicationController

  RepublishWindow = 6.hours

  before_filter :require_user

  def show
    @profile = current_user.profile(current_site)
    respond_to do |format|
      format.html
    end
  end

  def edit
    @wave = current_user.profile(current_site)
    respond_to do |format|
      format.html
    end
  end
  
  def update
    profile = current_user.profile(current_site)
    # TODO: All updates should go through the profile itself,
    # not the resource so as to get the before_save call back,
    # thereby avoid the need to manually call set_tag_list_on.
    profile.resource.update_attributes(params[:user_info])
    profile.set_tag_list_on!(current_site)
    respond_to do |format|
      format.html { redirect_to profile_path }
    end
  end
  
  def avatar
    posting = Posting::Avatar.new(params[:posting_avatar]).tap do |avatar|
      avatar.user = current_user
      avatar.active = true
      avatar.state = :published
    end
    if posting.valid?
      current_user.profile(current_site).postings << posting
      home_wave = current_site.home_wave
      home_wave.postings.type(Posting::Avatar).user(posting.user).published.where(:created_at => (Time.now - RepublishWindow)...Time.now).map(&:unpublish!)
      home_wave.postings << posting
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end
