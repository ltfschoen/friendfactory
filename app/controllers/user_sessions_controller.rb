class UserSessionsController < ApplicationController

  def destroy
    destroy_session
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private

  def destroy_session
    clear_lurker
    if current_user
      current_user.user.update_attribute(:current_login_at, nil)
      current_user_session.destroy
    end
  end

end
