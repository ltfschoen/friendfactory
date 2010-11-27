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
    
    remove_column :postings, :private rescue nil
    remove_column :postings, :receiver_id rescue nil
    remove_column :postings, :read_at rescue nil
    remove_column :postings, :sender_deleted_at rescue nil
    remove_column :postings, :receiver_deleted_at rescue nil    
  end

  def self.down
    drop_table :notifications rescue nil
    add_column :postings, :private, :boolean, :default => false
    add_column :postings, :receiver_id, :integer
    add_column :postings, :read_at, :datetime
    add_column :postings, :sender_deleted_at, :datetime
    add_column :postings, :receiver_deleted_at, :datetime    
    add_index  :postings, :receiver_id
  end
end
