class Wave::AlbumsController < ApplicationController
  
  before_filter :require_user  

  def index
    @waves = Wave::Album.published.order('created_at desc')
  end
    
  def show
    @wave = current_site.waves.find_by_id(params[:id])
    @start_slide = start_slide(params[:photo_id])
    respond_to do |format|
      format.html { render :layout => 'album' }
    end
  end
    
  def create
    @wave = nil
    if params[:wave_id].present?
      @wave = current_site.waves.type(Wave::Album).find_by_id(params[:wave_id])
    end
    unless @wave.present?
      @wave = Wave::Album.new do |wave|
        wave.user = current_user
        wave.state = :unpublished
      end
      if @wave.save
        current_site.waves << @wave
      end
    end
    if @wave.postings << new_posting_photo
      current_user.find_or_create_photos_wave.postings << new_posting_photo
      render :json => created_wave_to_json(@wave, @posting), :content_type => 'text/html'
    else
      render :json => { :result => 'error' }, :content_type => 'text/html'      
    end
  end
    
  private

  def new_posting_photo
    @posting ||= begin
      Posting::Photo.new(params[:posting_photo]).tap do |posting|
        posting.user = current_user
        posting.state = :published
      end
    end
  end
  
  def created_wave_to_json(wave, posting)
    { :wave_id    => wave.id,
      :dom_id     => dom_id(posting),
      :image_path => (posting.horizontal? ? posting.image.url(:h4x6) : posting.image.url(:v4x6)),
      :name       => posting.image.instance.attributes["image_file_name"],
      :horizontal => posting.horizontal? }
  end
  
  def start_slide(photo_id)
    if photo_id.present?
      @wave.photos.each_with_index do |photo, idx|
        return (idx + 1) if photo.id == photo_id.to_i
      end
    end
    1
  end
  
end