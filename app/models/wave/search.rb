class Wave::Search
  
  attr_reader :postings
  
  def initialize(postings = [])
    @postings = postings
  end
  
end
