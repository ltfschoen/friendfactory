class ProfilesController < ApplicationController

  before_filter :require_lurker, :only => [ :show ]
  before_filter :require_user,   :only => [ :edit, :update ]

  helper :waves
  
  def show
    @wave = Wave::Base.find_by_id_and_type(params[:id], 'Wave::Profile')
    respond_to do |format|
      format.html
    end
  end

  def edit
    @wave = current_user.profile
    current_user.save && current_user.reload if (current_user.profile.nil? || current_user.info.nil?)
    respond_to do |format|
      format.html { render :action => 'show' }
    end
  end
  
  def update
    current_user.info.update_attributes(params[:user_info])    
    respond_to do |format|
     format.json { render :json => { :errors => @current_user.info.errors }}
    end
  end

  def photo
    @photo = Posting::Photo.new(params[:posting_photo])
    current_user.postings << @photo
    current_user.profile.postings << @photo
    respond_to_parent do
      respond_to do |format|
        format.js
      end
    end
  end
  
end
