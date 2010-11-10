class UserSessionsController < ApplicationController
  
  before_filter :require_lurker, :only => :new
  before_filter :require_user,   :only => :destroy
    
  def new    
    store_reentry_location
  end  
  
  def create
    @user_session = UserSession.new(params[:user_session])
    respond_to do |format|
      if @user_session.save        
        user = @user_session.record        
        clear_lurker
        flash[:notice] = "Welcome back" + (user.first_name? ? ", #{user.first_name}" : '') + '!'
        format.html { redirect_back_or_default(root_path) }
      else
        flash[:notice] = 'Sorry, but that email is not being used at FriskyHands.'
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
    current_user.update_attribute(:current_login_at, nil)
    current_user_session.destroy
    clear_lurker
    Broadcast.user_offline('friskyhands', current_user)
    respond_to do |format|
      format.html { redirect_to welcome_url }
    end
  end

end
