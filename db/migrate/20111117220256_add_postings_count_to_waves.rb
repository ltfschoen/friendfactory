class AddPostingsCountToWaves < ActiveRecord::Migration
  def self.up
    add_column :waves, :postings_count, :integer, :default => 0 rescue nil

    # Remove Wave::Inbox obsolete class
    Wave::Base.delete_all(:type => 'Wave::Inbox')

    Wave::Base.reset_column_information
    ActiveRecord::Base.record_timestamps = false
    Wave::Base.all.each do |wave|
      wave.update_attribute(:postings_count, wave.postings.published.count)
    end
  end

  def self.down
    remove_column :waves, :postings_count rescue nil
  end
end
