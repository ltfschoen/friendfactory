class HomeController < ApplicationController  
  
  def welcome
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html do
          flash[:success] = "We can't wait to connect with you!"
          redirect_to :back
        end
      else
        format.html do
          flash[:failure] = "Mmm... that doesn't seem to be a valid email"
          redirect_to :back
        end
      end
    end
  end
  
end