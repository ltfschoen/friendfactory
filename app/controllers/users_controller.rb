class UsersController < ApplicationController

  before_filter :require_no_user, :only => [ :new, :create ]

  # def show
  #   @profile = current_user    
  # end

  def new
    store_reentry_location
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|      
      if @user.save
        flash[:internal] = 'user-create'
        format.html { redirect_to root_path }
      else
        flash[:errors] = @user.errors.full_messages
        format.html { redirect_back_to_reentry }
      end
    end
  end
  
end
