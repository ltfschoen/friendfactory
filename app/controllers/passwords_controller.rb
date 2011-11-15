class PasswordsController < ApplicationController

  before_filter :require_no_user
  before_filter :find_user_by_perishable_token, :only => [ :edit, :update ]

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
    render :layout => 'welcome'
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = 'Your password was successfully updated.'
      redirect_to root_path
    else
      render :action => 'edit', :layout => 'welcome'
    end
  end

  private

  def find_user_by_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = %{
        Sorry, but we could not locate your account.
        If you are having issues try copying and pasting the URL
        from your email into your browser or restarting the
        reset password process. }
      redirect_to root_url   
    end
  end

end
