require 'user_enrollment'

class UsersController < ApplicationController

  include UserEnrollment

  before_filter :require_no_user
  
  def create
    @user = new_user_enrollment(params[:user])
    respond_to do |format|
      if @user.valid? && correct_credentials?(@user)
        @user.save
        flash[:notice] = "Welcome to #{current_site.display_name}, #{@user.handle(current_site)}!"
        format.html { redirect_to root_path }
      else
        flash.now[:errors] = @user.errors.full_messages
        flash.now[:errors] += user_session.errors.full_messages if user_session
        format.html { render :template => 'welcome/show', :layout => 'welcome' }
      end
    end    
  end
  
  alias :update :create

  def member
    user = User.find_by_email(params[:email])
    respond_to do |format|
      format.json { render :json => { :member => user.present? } }
    end
  end
  
  private
    
  def correct_credentials?(user)
    (user.existing_record? && login(user_email_and_password, :skip_enrollment_validation => true)) || @user.new_record?
  end

  def user_email_and_password
    params[:user].select { |k, v| [ 'email', 'password' ].include?(k) }
  end
  
end
