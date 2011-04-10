class Wave::ProfileController < ApplicationController

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
    current_user.profile(current_site).resource.update_attributes(params[:user_info])
    respond_to do |format|
      format.html { redirect_to profile_path }
    end
  end
  
  def avatar
    if wave = current_user.profile(current_site)
      posting = Posting::Avatar.new(params[:posting_avatar]).tap do |avatar|
        avatar.user = current_user
        avatar.active = true
      end
      wave.postings << posting
      posting.publish!
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end
