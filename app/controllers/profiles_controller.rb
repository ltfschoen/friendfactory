class ProfilesController < ApplicationController

  before_filter :require_lurker, :only => [ :show ]
  before_filter :require_user,   :only => [ :edit, :update ]

  def show
    @wave = Wave::Base.find_by_id_and_type(params[:id], 'Wave::Profile')
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

  def edit_photo
     @photo = current_user.profile.photos.build(params[:posting_photo])
     current_user.profile.save
     respond_to_parent do
       respond_to do |format|
         format.js
       end
     end
  end
  
end
