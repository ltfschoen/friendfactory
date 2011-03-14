class Wave::AlbumsController < ApplicationController
  
  before_filter :require_user  
    
  def show
    respond_to do |format|
      format.html { render :layout => 'wave_album' }
    end
  end
    
  def create
    create_wave_album unless params[:wave_id].present?
    if wave.postings << posting
      render :json => success_state, :content_type => 'text/html'  
    else
      render :json => { :result => 'error' }, :content_type => 'text/html'      
    end
  end
    
  private

  def wave
    @wave ||= Wave::Album.find_by_id(params[:wave_id])
  end
  
  def posting
    @posting ||= begin
      Posting::Photo.new(params[:posting_photo]).tap do |posting|
        posting.user = current_user
        posting.state = :published
      end
    end
  end
      
  def create_wave_album
    @wave = Wave::Album.create(:user => current_user, :state => :unpublished)
  end
  
  def success_state
    { :wave_id    => wave.id,
      :dom_id     => dom_id(posting),
      :image_path => (posting.horizontal? ? posting.image.url(:h4x6) : posting.image.url(:v4x6)),
      :name       => posting.image.instance.attributes["image_file_name"],
      :horizontal => posting.horizontal? }
  end
  
end