class Waves::PolaroidsController < Waves::BaseController

  PolaroidWave = Struct.new('PolaroidWave', :id, :topic, :postings)

  def index    
    postings = Posting::Avatar.active
    wave_id  = '000'
    @wave = PolaroidWave.new(wave_id, 'Polaroids', postings)
    respond_to do |format|
      format.html
    end
  end

end
