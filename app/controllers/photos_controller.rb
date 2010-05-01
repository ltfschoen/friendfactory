class PhotosController < ApplicationController

  before_filter :require_user
  
  def create
    @photo = current_user.profile.photos.build(params[:posting_photo])
    current_user.profile.save
    respond_to_parent do      
      respond_to do |format|
        format.js
      end
    end
  end
    
end