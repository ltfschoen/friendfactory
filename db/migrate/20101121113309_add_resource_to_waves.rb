class AddResourceToWaves < ActiveRecord::Migration
  def self.up
    add_column :waves, :resource_id, :integer
    add_column :waves, :resource_type, :string
    add_index  :waves, [ :resource_id, :resource_type ]
  end

  def self.down
    remove_column :waves, :resource_id rescue nil
    remove_column :waves, :resource_type rescue nil
  end
end
