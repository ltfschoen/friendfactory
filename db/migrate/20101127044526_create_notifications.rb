class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications, :force => true do |t|
      t.integer   :user_id
      t.integer   :posting_id
      t.datetime  :created_at
      t.datetime  :read_at
    end
    add_index :notifications, [ :user_id, :posting_id ]
    add_index :notifications, :posting_id
  end

  def self.down
    drop_table :notifications rescue nil
  end
end
