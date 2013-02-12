class Feed

  class << self
    def find id
      new Wave::Base.find id 
    end
  end

  def postings
    feed.postings
  end

  private

  def initialize feed
    @feed = feed
  end

  def feed
    @feed
  end

end
