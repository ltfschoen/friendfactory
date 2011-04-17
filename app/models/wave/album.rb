class Wave::Album < Wave::Base
  
  def photos
    postings.published.order('created_at asc')
  end
  
  def self.find_or_create(site, user, params)
    if params[:wave_id].present?
      Wave::Album.joins(:sites).where(:sites => { :id => site.id }).find_by_id(params[:wave_id])
    else      
      Wave::Album.new(:state => :unpublished).tap do |wave|
        wave.user = user
        site.waves << wave
        wave.reload
      end
    end
  end
  
end