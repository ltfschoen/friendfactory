class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :force => true do |t|
      t.integer             :sender_id,   :null => false
      t.integer             :receiver_id, :null => false
      t.integer             :parent_id
      t.text                :subject
      t.text                :body
      t.timestamps
      t.datetime            :read_at
      t.datetime            :sender_deleted_at
      t.datetime            :receiver_deleted_at
    end
    add_index :messages, :sender_id
    add_index :messages, :receiver_id
    add_index :messages, :parent_id
  end

  def self.down
    drop_table :messages rescue nil
  end
end