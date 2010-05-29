class UsersController < ApplicationController

  before_filter :require_no_user, :only => [ :create ]

  # def show
  #   @profile = current_user    
  # end

  def create
    @user = User.new(params[:user])
    respond_to do |format|      
      if @user.save        
        Broadcast.user_create('friskyhands', @user)
        Pusher['wave'].trigger('user-register', { :full_name => @user.full_name })      
        format.html { redirect_to edit_profile_path}
      else
        flash[:errors] = @user.errors.full_messages
        format.html { redirect_back_or_default(welcome_path) }
      end
    end
  end
  
end
