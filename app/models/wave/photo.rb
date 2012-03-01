class Wave::Photo < Wave::Base

  def photos
    postings.type(Posting::Photo).order('`updated_at` DESC')
  end

end
