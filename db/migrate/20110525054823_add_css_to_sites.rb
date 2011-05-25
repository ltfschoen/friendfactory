class AddCssToSites < ActiveRecord::Migration
  def self.up
    remove_index :sites, :name
    add_index :sites, :name, :unique => true
    add_column :sites, :css, :text
  end

  def self.down
    remove_column :sites, :css
    remove_index :sites, :name
  end
end
