class AddHashKeyToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :hash_key, :string, :limit => 8
  end

  def self.down
    remove_column :postings, :hash_key
  end
end
