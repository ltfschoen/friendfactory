class Waves::ProfileController < Waves::BaseController

  before_filter :require_user

  helper :waves

  def show
    @wave = current_user.profile
    respond_to do |format|
      format.html
    end
  end

  def edit
    @wave = current_user.profile
    respond_to do |format|
      format.html
    end
  end
  
  def update
    current_user.info.update_attributes(params[:user_info])
    respond_to do |format|
      format.html { redirect_to profile_path }
    end
  end
  
  def avatar
    if params[:posting_avatar]
      current_user.profile.avatars.create(:image => params[:posting_avatar][:image], :user_id => current_user.id, :active => true)
    end
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
