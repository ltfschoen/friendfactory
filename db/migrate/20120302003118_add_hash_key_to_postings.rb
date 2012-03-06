class AddHashKeyToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :hash_key, :string, :limit => 8
    ActiveRecord::Base.transaction do
      Posting::Base.all.each do |posting|
        posting.send(:set_hash_key)
        posting.save(:validate => false)
      end
    end
  end

  def self.down
    remove_column :postings, :hash_key
  end
end
