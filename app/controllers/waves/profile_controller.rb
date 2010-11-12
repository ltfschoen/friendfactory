class Waves::ProfileController < Waves::BaseController

  before_filter :require_user

  helper :waves

  def show
    @wave = current_user.profile
    respond_to do |format|
      format.html
    end
  end
  
  def update
    @successful = current_user.info.update_attributes(params[:user_info])
    respond_to do |format|
      format.js { render :layout => false }
    end
  end

end
