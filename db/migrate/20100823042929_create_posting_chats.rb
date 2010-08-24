class CreatePostingChats < ActiveRecord::Migration
  def self.up
    create_table :posting_chats do |t|
      t.integer   :receiver_id
      t.text      :body
    end
    add_index :posting_chats, :receiver_id
  end

  def self.down
    drop_table :posting_chats rescue nil
  end
end
