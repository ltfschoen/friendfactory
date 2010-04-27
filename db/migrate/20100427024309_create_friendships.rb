class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :buddy_id
      t.timestamps
    end
  end

  def self.down
    drop_table :friendships rescue nil
  end
end
