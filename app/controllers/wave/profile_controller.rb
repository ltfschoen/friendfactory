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
    if profile = current_user.profile(current_site)
      profile.resource.update_attributes(params[:user_info])
      profile.save
    end
    respond_to do |format|
      format.html { redirect_to profile_path }
    end
  end
  
  def avatar
    if params[:posting_avatar]     
      current_user.profile(current_site).avatars.create(:image => params[:posting_avatar][:image], :user_id => current_user.id, :active => true)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end
  
end
