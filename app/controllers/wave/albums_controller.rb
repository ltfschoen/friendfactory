class Wave::AlbumsController < ApplicationController
  
  before_filter :require_user  
    
  def create
    create_wave_album unless params[:wave_id].present?
    if wave.postings << posting
      render :json => results, :content_type => 'text/html'  
    else
      render :json => { :result => 'error' }, :content_type => 'text/html'      
    end
  end
    
  private
  
  def posting
    @posting ||= begin
      Posting::Photo.new(params[:posting_photo]).tap do |posting|
        posting.user = current_user
        posting.state = :published
      end
    end
  end
  
  def wave
    @wave ||= Wave::Album.find_by_id(params[:wave_id])
  end
    
  def create_wave_album
    @wave = Wave::Album.create(:user => current_user, :state => :unpublished)
  end
  
  def results
    { :wave_id    => wave.id,
      :dom_id     => dom_id(posting),
      :image_path => (posting.horizontal? ? posting.image.url(:h4x6) : posting.image.url(:v4x6)),
      :name       => posting.image.instance.attributes["image_file_name"],
      :horizontal => posting.horizontal? }
  end
  
end