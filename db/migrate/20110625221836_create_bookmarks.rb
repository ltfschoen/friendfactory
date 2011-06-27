class CreateBookmarks < ActiveRecord::Migration
  def self.up
    create_table :bookmarks, :force => true do |t|
      t.integer  :wave_id
      t.integer  :user_id
      t.datetime :created_at
      t.datetime :read_at
    end
    add_index :bookmarks, [ :wave_id, :user_id ]
    add_index :bookmarks, :user_id
    
    say "Randomize uploaded image filenames"
    say "ff:fix:randomize_file_names", true
  end

  def self.down
    drop_table :bookmarks rescue nil
  end
end
