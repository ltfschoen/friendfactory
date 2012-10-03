class AddStickyToPostings < ActiveRecord::Migration
  def self.up
    rename_column :postings, :image_updated_at, :sticky_until
    # Posting::Base.update_all(:sticky_until => nil)
  end

  def self.down
    rename_column :postings, :sticky_until, :image_updated_at
  end
end
