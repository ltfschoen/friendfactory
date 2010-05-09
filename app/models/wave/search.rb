class Wave::Search
  
  attr_reader :params
  attr_reader :postings
  
  def initialize(params, postings = [])
    @params   = params
    @postings = postings
  end
  
end
