class UserSessionsController < ApplicationController
  
  before_filter :require_lurker, :only => :new
    
  def new    
    store_reentry_location
  end  
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.remember_me = true || params.has_key?(:remember_me)
    respond_to do |format|
      if login_user(@user_session)
        clear_lurker
        user = @user_session.record
        flash[:notice] = "Welcome back" + (user.handle(current_site) ? ", #{user.handle(current_site)}" : '') + '!'
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
    destroy_session
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end
  
  private
  
  def login_user(user_session)    
    if user_session.save && user = user_session.record      
      if user.site_ids.include?(current_site.id)
        user
      else
        destroy_session
        user_session.errors.add(:base, I18n.t("error_messages.invalid_email", :default => "email is not valid"))
        false
      end
    end
  end
  
  def destroy_session
    clear_lurker
    if current_user
      current_user.update_attribute(:current_login_at, nil)
      current_user_session.destroy
    end
  end

end
