class HomeController < ApplicationController  

  before_filter :require_no_user

  def index
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html do
          flash[:success] = true
          redirect_to :back
        end
      else
        raise @user.errors.inspect
        format.html do
          flash[:success] = false
          redirect_to :back
        end
      end
    end
  end  
  
end
