class Wave::AlbumsController < ApplicationController
  
  before_filter :require_user  
    
  def show
    @wave = Wave::Album.find_by_id(params[:album_id])    
    @start_slide = start_slide(params[:id])
    respond_to do |format|
      format.html { render :layout => 'wave_album' }
    end
  end
    
  def create
    @wave = find_or_create_wave_album
    if @wave.postings << new_posting_photo
      render :json => created_wave_to_json(@wave, @posting), :content_type => 'text/html'
    else
      render :json => { :result => 'error' }, :content_type => 'text/html'      
    end
  end
    
  private

  def find_or_create_wave_album
    if params[:wave_id].present?
      Wave::Album.find_by_id(params[:wave_id])
    else
      Wave::Album.new(:state => :unpublished).tap { |wave| wave.user = current_user }
      current_site.waves << wave
    end
  end

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