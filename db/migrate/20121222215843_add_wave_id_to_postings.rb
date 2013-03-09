class AddWaveIdToPostings < ActiveRecord::Migration

  class Publication < ActiveRecord::Base
    self.table_name = "publications"
  end

  class Posting < ActiveRecord::Base
    self.table_name = "postings"
  end

  def up
    add_column :postings, :wave_id, :integer
    initialize_feed_id
  end

  def down
    remove_column :postings, :wave_id
  end

  def initialize_feed_id
    postings.find_in_batches do |postings_batch|
      transaction do
        postings_batch.each do |posting|
          if publication = posting.publishables.order(%q{"id" ASC}).first
            posting.update_attribute :wave_id, publication.wave_id
          end
        end
      end
    end
  end

  def transaction
    Posting.transaction { yield }
  end
  
  def postings
    Posting.where(id: posting_ids, wave_id: nil)
  end

  def posting_ids
    Publication.select("distinct posting_id").order("posting_id ASC").map(&:posting_id)
  end

end


