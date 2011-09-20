class AddTypeToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :type, :string
    add_index :assets, [ :name, :type ]
    add_index :assets, [ :type ]
    Asset::Base.update_all(:type => 'Asset::Image')
  end

  def self.down
    remove_column :assets, :type
  end
end
