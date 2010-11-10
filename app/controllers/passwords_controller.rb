class PasswordsController < ApplicationController

  before_filter :require_no_user
  before_filter :find_user_by_perishable_token, :only => [ :edit, :update ]
  
  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.reset_password!
      PasswordsMailer.reset(@user).deliver
      flash[:notice] = 'Thanks! Instructions to reset your password have been emailed to you.'
      redirect_to welcome_path
    else
      flash[:notice] = 'Sorry, but that email is not being used at FriskyHands.'
      redirect_to welcome_path
    end
  end
  
  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = 'Your password was successfully updated'
      redirect_to root_path
    else
      render :action => 'edit'
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
