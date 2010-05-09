class ProfilesController < ApplicationController

  before_filter :require_user,   :only => [ :edit, :update ]
  before_filter :require_lurker, :only => [ :show ]

  def show
    @profile = Wave::Base.find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # def home
  #   respond_to do |format|
  #     format.html { render :partial => 'home' }
  #   end
  # end

  def edit
    @profile   = current_user.profile
    @user_info = current_user.info
    if (current_user.profile.nil? || current_user.info.nil?)
      current_user.save && current_user.reload
    end
    respond_to do |format|
      format.html
    end
  end

  def update
    current_user.info.update_attributes(params[:user_info])    
    respond_to do |format|
     format.json { render :json => { :errors => @current_user.info.errors }}
    end
  end
  
end
