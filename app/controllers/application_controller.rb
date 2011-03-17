require 'exceptions'
require 'pusher'

class ApplicationController < ActionController::Base

  # include ActionController::Sites
    
  protect_from_forgery

  filter_parameter_logging(:password, :password_confirmation) if Rails.env.production?

  helper :all
  helper_method :current_user_session, :current_user
  helper_method :current_site  
  helper_method :presenter

  rescue_from UnauthorizedException do |exception|
    render :file => "#{Rails.root}/public/401.html", :status => 401
  end
  
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def current_site
    @current_site ||= begin
      site_name = request.domain && request.domain.gsub(/\..*$/, '')
      site_name = ActionController::Base.localhost if [ nil, 'localhost' ].include?(site_name)
      Site.find_by_name(site_name)
    end
  end
  
  def require_user
    unless current_user
      store_location
      if request.xhr?
        render :update do |page|
          page << "document.location='#{welcome_url}'"
        end
        return false
      else
        # flash[:notice] = "You must be logged in to access this page"
        redirect_to welcome_url
        return false
       end
    end
  end

  def require_lurker
    unless current_user || lurker
      store_location
      redirect_to welcome_url
      return false
    end
  end
  
  def require_admin
    unless current_user && current_user.admin?
      redirect_to welcome_url
      return false
    end
  end
  
  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to logout_url
      return false
    end
  end
  
  def require_launch
    redirect_to launch_url
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end

  def store_reentry_location
    session[:reentry_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
    session[:reentry_to] = nil
  end
  
  def redirect_back_to_reentry
    redirect_to(session[:reentry_to])
    session[:reentry_to] = nil
  end
  
  def store_lurker
    session[:lurker] = true
  end
    
  def clear_lurker
    session[:lurker] = nil
  end
      
  def lurker
    session[:lurker].present? && session[:lurker] == true
  end
        
  def presenter
    @presenter ||= ApplicationPresenter.new(params)
  end

end
