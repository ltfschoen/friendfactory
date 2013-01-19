class CreateStylesheets < ActiveRecord::Migration
  def self.up
    create_table :stylesheets, :force => true do |t|
      t.integer :site_id, :null => false
      t.string  :controller_name
      t.text    :css
      t.timestamps :null => true
    end
    # remove_column :sites, :css
    add_index :stylesheets, [ :site_id, :controller_name ]
  end

  def self.down
    add_column :sites, :css, :text rescue nil
    drop_table :stylesheets rescue nil
  end
end
