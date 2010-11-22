class Waves::RollCallsController < Waves::BaseController

  RollCallWave   = Struct.new('RollCallWave', :id, :topic, :profiles)
  RollCallWaveID = '000'

  def index
    profiles = if params[:tag]
      UserInfo.tagged_with(params[:tag]).map(&:profile)
    else
      Wave::Profile.all_with_active_avatars.includes(:resource, :avatars)
    end
    @wave = RollCallWave.new(RollCallWaveID, 'Roll Call', profiles)
    @tags = UserInfo.tag_counts_on(:tags)
    respond_to do |format|
      format.html
    end
  end

end
