class CreateTextPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :body, :text
  end
  
  def self.down
    remove_column :postings, :body rescue nil
  end
end
