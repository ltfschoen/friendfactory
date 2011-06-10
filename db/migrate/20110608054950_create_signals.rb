class CreateSignals < ActiveRecord::Migration
  def self.up
    create_table :signals, :force => true do |t|
      t.string :name, :null => false
      t.string :display_name
      t.string :type
    end
    add_index :signals, :name, :unique => true

    create_table :signal_categories, :force => true do |t|
      t.string  :name, :null => false
      t.string  :display_name
      t.integer :site_id
      t.string  :subject_type
      t.integer :ordinal
    end
    add_index :signal_categories, :site_id

    create_table :signal_categories_signals, :force => true do |t|
      t.integer :signal_id
      t.integer :category_id
      t.integer :ordinal
    end
    add_index :signal_categories_signals, [ :category_id, :signal_id ], :uniq => true
  end

  def self.down
    drop_table :signals rescue nil
    drop_table :signal_categories rescue nil
    drop_table :signal_categories_signals rescue nil
  end
end
