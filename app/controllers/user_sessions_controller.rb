class UserSessionsController < ApplicationController
  
  before_filter :require_lurker, :only => :new
    
  def new    
    store_reentry_location
  end  
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = params.has_key?(:remember_me)
    respond_to do |format|
      if @user_session.save        
        user = @user_session.record        
        clear_lurker
        flash[:notice] = "Welcome back" + (user.first_name? ? ", #{user.first_name}" : '') + '!'
        format.html { redirect_back_or_default(root_path) }
      else
        flash[:notice] = "Sorry, but the #{@user_session.errors.full_messages.first.downcase}."
        format.html { redirect_back_to_reentry }
      end
    end
  end
  
  def lurk
    store_lurker
    respond_to do |format|
      format.html { redirect_back_or_default(root_path) }
    end
  end

  def destroy
    if current_user.present?
      current_user.update_attribute(:current_login_at, nil)
      current_user_session.destroy
      clear_lurker
    end
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

end
