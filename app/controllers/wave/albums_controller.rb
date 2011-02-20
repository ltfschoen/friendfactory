class Wave::AlbumsController < ApplicationController
  
  before_filter :require_user  
    
  def create
    create_and_publish_wave_album unless params[:wave_id].present?
    if wave.postings << posting
      render :json => {
        :wave_id    => wave.id,
        :dom_id     => dom_id(posting),
        :image_path => posting.image.url.to_s,
        :horizontal => posting.horizontal?
        # :name     => posting.image.instance.attributes["image_file_name"]
      }, :content_type => 'text/html'
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
    
  def create_and_publish_wave_album
    publish_id = params[:publish_id]
    @wave = Wave::Album.create(:user => current_user, :state => :unpublished).tap do |wave|
      if publish_id.present? && (publish_wave = Wave::Base.find_by_id(publish_id))
        publish_wave.postings << Posting::WaveProxy.new.tap do |proxy|
          proxy.user = current_user
          proxy.resource = wave
          proxy.state = :published
        end
      end
    end
  end
  
end