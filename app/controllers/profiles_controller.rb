class ProfilesController < ApplicationController

  before_filter :require_user
  
  def show
    @profile = Wave::Base.find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def edit
    @profile   = current_user.profile
    @user_info = current_user.info
    current_user.save && current_user.reload if (current_user.profile.nil? || current_user.info.nil?)
    respond_to do |format|
      format.html
    end
  end

  def create
    posting_type = params[:posting_type]
    self.send("create_#{posting_type.to_sym}")
  end

  def update
    @success = current_user.info.update_attributes(params[:user_info])
    respond_to do |format|
      format.js
    end
  end
  
  private

  def create_posting_avatar
    @avatar = current_user.profile.build_avatar(params[:posting_avatar])
    current_user.profile.save
    respond_to_parent do
      respond_to do |format|
        format.js  { render :action => 'create_avatar' }
      end
    end
  end
  
  def create_posting_photo
    @photo = current_user.profile.photos.build(params[:posting_photo])
    current_user.profile.save
    respond_to_parent do      
      respond_to do |format|
        format.js { render :action => 'create_photo' }
      end
    end
  end

end
