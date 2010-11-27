class Waves::RollCallsController < Waves::BaseController

  RollCallWave   = Struct.new('RollCallWave', :id, :topic, :profiles)
  RollCallWaveID = '000'

  before_filter :require_lurker

  def index
    profiles = if params[:tag]
      params[:tag] = params[:tag].downcase.gsub(/-/, ' ')
      UserInfo.tagged_with(params[:tag]).map(&:profile)
    else
      Wave::Profile.includes(:resource, :avatars).order('updated_at desc')
    end
    @wave = RollCallWave.new(RollCallWaveID, 'Roll Call', profiles)
    @tags = UserInfo.tag_counts_on(:tags).order('name asc')
    respond_to do |format|
      format.html
    end
  end

end
