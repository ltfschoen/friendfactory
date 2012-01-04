require 'exceptions'
require 'pusher'

class ApplicationController < ActionController::Base

  protect_from_forgery

  if Rails.env.development?
    [ 'ambassador' ].each do |dep|
      require_dependency(File.join(Rails.root, 'app', 'models', 'wave', dep))
    end
  end

  helper_method \
      :current_user_session,
      :current_user,
      :current_profile,
      :current_person,
      :current_site,
      :presenter,
      :resolver

  rescue_from UnauthorizedException do |exception|
    render :file => "#{Rails.root}/public/401.html", :status => 401
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = current_site.user_sessions.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def current_profile
    return @current_profile if defined?(@current_profile)
    if current_user
      @current_profile = current_user.profile(current_site)
    end
  end

  def current_persona
    return @current_persona if defined?(@current_persona)
    if current_user
      @current_persona = current_user.persona
    end
  end

  alias :current_person :current_persona

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
    unless current_user && current_user.administrator?
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
  
  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
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
  
  def resolver
    params[:resolver] || controller_name.singularize
  end

end
