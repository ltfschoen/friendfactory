require 'rake'

class AddDimensionsToPosting < ActiveRecord::Migration
  def self.up
    add_column :postings, :width, :integer
    add_column :postings, :height, :integer
    add_column :postings, :horizontal, :boolean

    puts '-- Now perform the following rake tasks:'
    puts '--  ff:attachments:delete!'
    puts '--  ff:attachments:reprocess!'
    puts '--  ff:attachments:geometry!'
    puts '--  ff:db:refresh:default_wave'
  end

  def self.down
    remove_column :postings, :width rescue nil
    remove_column :postings, :height rescue nil
    remove_column :postings, :horizontal rescue nil
  end
end
