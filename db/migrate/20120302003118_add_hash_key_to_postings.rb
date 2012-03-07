class AddHashKeyToPostings < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false
    add_column :postings, :hash_key, :string, :limit => 8
    ActiveRecord::Base.transaction do
      Posting::Base.where(:type => [ 'Posting::Photo', 'Posting::Avatar']).find_each do |posting|
        posting.send(:set_hash_key)
        posting.save(:validate => false)
      end
    end
    ActiveRecord::Base.record_timestamps = true
  end

  def self.down
    remove_column :postings, :hash_key
  end
end
