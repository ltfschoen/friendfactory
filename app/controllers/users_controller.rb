class UsersController < ApplicationController

  before_filter :require_no_user, :only => [ :new, :create ]

  def new
    store_reentry_location
  end

  def create
    @user = find_or_create_user_for_site
    respond_to do |format|      
      if @user.save
        format.html { redirect_to root_path }
      else
        flash[:error] = @user.errors.full_messages
        format.html { redirect_back_to_reentry }
      end
    end
  end
  
  private
  
  def find_or_create_user_for_site
    @user = User.find_by_email(params[:user][:email]) || User.new(params[:user])
    @user.current_site = current_site
    @user
  end
  
end
