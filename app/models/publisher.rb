class Publisher
  
  def initialize(publish_to)
    @publish_to = publish_to
  end
  
  def after_create(posting)
    wave = case
      when @publish_to[:slug].present? then Wave::Base.find_by_slug(@publish_to[:slug])
      when @publish_to[:wave] == Wave::Profile then Wave::Profile.find_by_user_id(posting.user_id)
    end
    if wave
      wave.postings << posting
    end
  end
  
end