class Wave::Album < Wave::Base

  def photos
    postings.type(Posting::Photo).published.order('"created_at" ASC').scoped
  end

  def fetchables(limit = nil)
    if fetchable?
      limit = (limit.to_i / 2 * 3) if limit.present?
      photos.limit(limit).offset(1).scoped
    else
      super
    end
  end

  def fetch_type
    fetchable? ? :wave_album : super
  end

  private

  def fetchable?
    photos.count > 1
  end

end
