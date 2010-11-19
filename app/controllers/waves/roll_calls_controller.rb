class Waves::RollCallsController < Waves::BaseController

  RollCallWave   = Struct.new('RollCallWave', :id, :topic, :postings)
  RollCallWaveID = '000'

  def index
    postings = Wave::Profile.avatars
    @wave = RollCallWave.new(RollCallWaveID, 'Roll Call', postings)
    respond_to do |format|
      format.html
    end
  end

end
