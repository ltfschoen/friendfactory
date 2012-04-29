class PublicationObserver < ActiveRecord::Observer

  observe Publication

  def after_create(publication)
    if publication.posting.published?
      publication.wave.increment!(:postings_count)
    end
  end

  def after_destroy(publication)
    publication.wave.decrement!(:postings_count)
  end

end
