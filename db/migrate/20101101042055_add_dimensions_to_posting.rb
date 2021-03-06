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
      # add_column :postings, :horizontal, :boolean
      add_column :postings, :horizontal, :integer
    end

    say "Set geometry for existing images"
    say 'ff:attachments:geometry!', true

    say 'Reprocess existing attachments'
    say 'ff:attachments:delete!', true
    say 'ff:attachments:reprocess!', true
  end

  def self.down
    remove_column :postings, :width rescue nil
    remove_column :postings, :height rescue nil
    remove_column :postings, :horizontal rescue nil
  end
end
