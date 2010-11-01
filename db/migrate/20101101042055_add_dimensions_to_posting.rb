class AddDimensionsToPosting < ActiveRecord::Migration
  def self.up
    add_column :postings, :width, :integer
    add_column :postings, :height, :integer
    add_column :postings, :horizontal, :boolean
  end

  def self.down
    remove_column :postings, :width rescue nil
    remove_column :postings, :height rescue nil
    remove_column :postings, :horizontal rescue nil    
  end
end
