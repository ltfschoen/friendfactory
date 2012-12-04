class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.string  :type
      t.integer :profile_id
      t.integer :friend_id
      t.timestamps :null => true
    end
    add_index :friendships, [ :type, :profile_id, :friend_id ], :unique => true
    add_index :friendships, [ :type, :friend_id ]
  end

  def self.down
    drop_table :friendships rescue nil
  end
end
