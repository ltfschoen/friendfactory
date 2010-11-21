class Waves::ProfilesController < Waves::BaseController

  before_filter :require_lurker, :only => [ :show ]
  before_filter :require_user,   :only => [ :edit, :update ]

  helper :waves
  
  def show
    @wave = Wave::Profile.find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  # GET photos for the mini-profile
  def photos
    wave = Wave::Profile.find_by_id(params[:id])
    if wave 
      @photos = wave.postings.only(Posting::Photo).limit(9)
    end
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
end
