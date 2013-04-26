class AddWaveIdToPostings < ActiveRecord::Migration

  class Publication < ActiveRecord::Base
    self.table_name = "publications"
  end

  class Posting < ActiveRecord::Base
    self.table_name = "postings"
    has_many :publishables, class_name: "Publication", foreign_key: "posting_id"
  end

  def up
    add_column :postings, :wave_id, :integer
    Posting.reset_column_information
    transaction { ignore_timestamps { initialize_postings }}
  end

  def down
    remove_column :postings, :wave_id rescue nil
  end

  def initialize_postings
    postings.each { |posting| initialize_posting posting }
  end

  def initialize_posting posting
    publications = posting.publishables.sort_by(&:id)
    if publication = publications.first
      posting.update_attribute :wave_id, publication.wave_id
    end
  end

  def ignore_timestamps
    ActiveRecord::Base.record_timestamps = false
    yield
    ActiveRecord::Base.record_timestamps = true
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

  def postings
    Posting.where(id: posting_ids, wave_id: nil).includes(:publishables)
  end

  def posting_ids
    Publication.select("distinct posting_id").map(&:posting_id)
  end

end


