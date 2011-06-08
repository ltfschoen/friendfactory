class CreateSignals < ActiveRecord::Migration
  def self.up
    create_table :signals, :force => true do |t|
      t.string  :name, :null => false
      t.string  :display_name, :null => false
      t.string  :type, :null => false
      t.timestamps
    end
    
    create_table :signal_ranges, :force => true do |t|
      t.integer :signal_id, :null => false
      t.string  :name, :null => false
      t.string  :display_name, :null => false
      t.string  :value
      t.integer :ordinal_position
      t.timestamps
    end
    
    create_table :sites_signals, :force => true, :id => false do |t|
      t.integer :site_id
      t.integer :signal_id
      t.timestamps
    end
    add_index :sites_signals, [ :site_id, :signal_id ]
    add_index :sites_signals, :signal_id
  end

  def self.down
    drop_table :signals rescue nil
    drop_table :signal_ranges rescue nil
    drop_table :sites_signals rescue nil
  end
end
