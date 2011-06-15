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
      t.integer :ordinal
    end
    add_index :signal_categories, :site_id

    create_table :signal_categories_signals, :force => true do |t|
      t.integer :signal_id
      t.integer :category_id
      t.integer :ordinal
    end
    add_index :signal_categories_signals, [ :category_id, :signal_id ], :uniq => true

    say "Seeding the database to load signals"
    say "ff:db:seed", true
    Rake::Task[:'ff:db:seed'].invoke

    say "Migrating sites to signals"
    say "ff:fix:site_signals", true
    Rake::Task[:'ff:fix:site_signals'].invoke

    say "Migrating profiles to signals"
    say "ff:fix:profile_signals", true
    Rake::Task[:'ff:fix:profile_signals'].invoke
  end

  def self.down
    drop_table :signals rescue nil
    drop_table :signal_categories rescue nil
    drop_table :signal_categories_signals rescue nil
  end
end
