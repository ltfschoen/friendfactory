class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites, :force => true do |t|
      t.string    :name, :null => false
      t.boolean   :launch
      t.string    :analytics_domain_name
      t.string    :analytics_account_number
      t.timestamps
    end
    add_column :waves, :site_id, :integer
    add_index :sites, :name
  end

  def self.down
    drop_table :sites rescue nil
    remove_column :waves, :site_id rescue nil
  end
end
