class Waves::RollCallsController < Waves::BaseController

  RollCallWave   = Struct.new('RollCallWave', :id, :topic, :profiles)
  RollCallWaveID = '000'

  def index
    profiles = Wave::Profile.scoped.includes(:resource, :avatars)
    @wave = RollCallWave.new(RollCallWaveID, 'Roll Call', profiles)
    respond_to do |format|
      format.html
    end
  end

end
