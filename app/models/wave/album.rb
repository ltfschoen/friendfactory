class Wave::Album < Wave::Base
  
  def photos
    postings.type(Posting::Photo).published.order('created_at asc')
  end
  
end