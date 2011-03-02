class Wave::Album < Wave::Base
  
  def photos
    postings.order('created_at asc')
  end
  
end