class Waves::PolaroidsController < Waves::BaseController

  DynamicWave = Struct.new('PolaroidWave', :id, :topic, :postings)
  @@dynamic_id = 0
  
  def index
    postings = Posting::Avatar.active
    @wave = DynamicWave.new(dynamic_id, 'Polaroids', postings)
    respond_to do |format|
      format.html
    end
  end

  def show
    @wave = Wave::Polaroid.find(params[:id])
    respond_to do |format|
      format.html
    end
  end
  
  private
  
  def dynamic_id
    @@dynamic_id += 1
  end

end
