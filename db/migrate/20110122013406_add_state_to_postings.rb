class AddStateToPostings < ActiveRecord::Migration
  def self.up
    add_column :postings, :state, :string
    Posting::Base.update_all({ :state => :published })
  end

  def self.down
    remove_column :postings, :state rescue nil
  end
end
