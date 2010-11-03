class CreatePostingChats < ActiveRecord::Migration
  def self.up
    unless table_exists?(:posting_chats)
      create_table :posting_chats do |t|
        t.integer   :receiver_id
        t.text      :body
      end
      add_index :posting_chats, :receiver_id
    end
  end

  def self.down
    drop_table :posting_chats rescue nil
  end
end
