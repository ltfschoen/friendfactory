class Wave::Photo < Wave::Base

  def photos
    postings.type(Posting::Photo)
  end

end
