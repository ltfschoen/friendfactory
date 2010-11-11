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
  
end
