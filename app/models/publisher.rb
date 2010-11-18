class Publisher
  
  def initialize(slug)
    @wave = Wave::Base.find_by_slug(slug)
  end
  
  def after_save(posting)
    if @wave.present?
      @wave.postings << posting
    end
  end
  
end