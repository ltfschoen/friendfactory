class PasswordsController < ApplicationController

  before_filter :require_no_user

  def new
    respond_to do |format|
      format.html { render :layout => 'welcome' }
    end
  end

  def create
    respond_to do |format|
      if user = User.find_by_email(params[:email])
        user.reset_password!
        PasswordsMailer.delay.reset(user, current_site)
        message = "Thanks! Instructions to reset your password have been emailed to #{user.email}"
        format.json { render :json => { :success => true, :message =>  message }}
      else
        message = "Drat! We can't find that email on #{current_site.display_name}"
        format.json { render :json => { :success => false, :message => message }}
      end
    end
  end

  def edit
    respond_to do |format|
      if @user = User.find_using_perishable_token(params[:id])
        format.html { render :layout => 'welcome' }
      else
        format.html { redirect_to welcome_url }
      end
    end
  end

  def update
    respond_to do |format|
      @user = User.find_using_perishable_token(params[:id])
      if @user && @user.update_attributes(params[:user])
        format.html do
          flash[:notice] = 'Your password was successfully updated.'
          redirect_to root_path
        end
      else
        format.html { render :action => 'edit', :layout => 'welcome' }
      end
    end
  end

end
