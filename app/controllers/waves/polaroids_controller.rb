class Waves::PolaroidsController < Waves::BaseController

  PolaroidWave   = Struct.new('PolaroidWave', :id, :topic, :postings)
  PolaroidWaveID = '000'

  def index    
    postings = Wave::Profile.avatars
    @wave = PolaroidWave.new(PolaroidWaveID, 'Polaroids', postings)
    respond_to do |format|
      format.html
    end
  end

end
