class Wave::Album < Wave::Base
  
  def photos
    postings.published.order('created_at asc')
  end
  
end