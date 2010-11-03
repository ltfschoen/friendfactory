require 'rake'

class AddDimensionsToPosting < ActiveRecord::Migration
  def self.up
    unless column_exists?(:postings, :width)
      add_column(:postings, :width, :integer)
    end
    
    unless column_exists?(:postings, :height)
      add_column(:postings, :height, :integer)
    end
    
    unless column_exists?(:postings, :horizontal)
      add_column(:postings, :horizontal, :boolean)
    end

    say 'now perform the following rake tasks:'
    say 'ff:attachments:delete!', true
    say 'ff:attachments:reprocess!', true
    say 'ff:attachments:geometry!', true
  end

  def self.down
    remove_column :postings, :width rescue nil
    remove_column :postings, :height rescue nil
    remove_column :postings, :horizontal rescue nil
  end
end
