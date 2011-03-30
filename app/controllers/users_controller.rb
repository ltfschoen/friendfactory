class UsersController < ApplicationController

  before_filter :require_no_user
  
  helper_method :new_user

  def member
    user = User.find_by_email(params[:email])
    respond_to do |format|
      format.json { render :json => { :member => user.present? } }
    end
  end

  def create
    create_or_update
  end
  
  def update
    create_or_update
  end
  
  private
  
  def create_or_update
    respond_to do |format|      
      @user = new_user_enrollment
      if ((@user.existing_record? && login) || @user.new_record?) && @user.save
        format.html { redirect_to root_path }
      else
        flash[:errors] = @user.errors.full_messages
        format.html { render :template => 'welcome/show', :layout => 'welcome' }
      end
    end    
  end

  def new_user_enrollment
    user_params = params[:user]
    if user = User.find_by_email(user_params[:email])
      user.new_enrollment(current_site, user_params[:handle], user_params[:invitation_code])   
    else
      User.new_user_enrollment(current_site, user_params)
    end
  end
  
  def login
    user_session = UserSession.new(:email => params[:user][:email], :password => params[:user][:password])
    user_session.remember_me = true
    user_session.skip_enrollment_validation = true
    unless login = user_session.save
      flash[:notice] = "Sorry, but that #{user_session.errors.full_messages.first.downcase}."
    end
    login
  end
    
end
