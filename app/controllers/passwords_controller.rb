class PasswordsController < ApplicationController

  before_filter :require_no_user

  def new
    render :layout => 'welcome'
  end

  def create
    respond_to do |format|
      if user = User.find_by_email(params[:email])
        user.reset_password!
        PasswordsMailer.reset(user, current_site).deliver
        message = "Thanks! Instructions to reset your password have been emailed to #{user.email}"
        format.json { render :json => { :success => true, :message =>  message }}
      else
        message = "Drat! We can't find that email on #{current_site.display_name}"
        format.json { render :json => { :success => false, :message => message }}
      end
    end
  end

  # PasswordsMailer email link
  def edit
    @user = User.find_using_perishable_token(params[:id])
    render :layout => 'welcome'
  end

  def update
    @user = User.find_using_perishable_token(params[:id])
    if @user && @user.update_attributes(params[:user])
      flash[:notice] = 'Your password was successfully updated.'
      redirect_to root_path
    else
      render :action => 'edit', :layout => 'welcome'
    end
  end

end
