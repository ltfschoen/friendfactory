class HomeController < ApplicationController  

  EmailPlaceholder = 'email@address.com'

  def index
    @email_placeholder = EmailPlaceholder
    respond_to do |format|
      format.html
    end
  end
  
  def welcome
    params[:user] && (params[:user][:email] != EmailPlaceholder) && (@user = User.new(params[:user]))
    respond_to do |format|
      @email_placeholder = EmailPlaceholder
      if @user && @user.save
        format.html do
          flash[:success] = true
          redirect_to :back
        end
      else
        format.html do
          flash[:failure] = true
          redirect_to :back
        end
      end
    end
  end
    
end