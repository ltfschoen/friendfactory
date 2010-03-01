class HomeController < ApplicationController  

  def index
   respond_to do |format|
      if true || current_user
        format.html
      else
        format.html { redirect_to new_user_session_path }
      end
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
        format.html do
          flash[:success] = false
          redirect_to :back
        end
      end
    end
  end  
  
end
