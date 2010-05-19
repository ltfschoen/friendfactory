class CreatePostingText < ActiveRecord::Migration
  def self.up
    add_column :postings, :subject, :text
    add_column :postings, :body,    :text
  end
  
  def self.down
    remove_column :postings, :subject rescue nil
    remove_column :postings, :body    rescue nil
  end
end
