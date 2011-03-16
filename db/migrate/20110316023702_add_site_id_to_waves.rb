class AddSiteIdToWaves < ActiveRecord::Migration
  def self.up
    add_column :waves, :site_id, :integer
    Wave::Base.update_all :site_id => FriskyhandsSite.new.id
  end

  def self.down
    remove_column :waves, :site_id rescue nil
  end
end
