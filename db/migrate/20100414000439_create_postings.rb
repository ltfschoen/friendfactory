class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings, :force => true do |t|
      t.string    :type
      t.string    :slug
      t.integer   :user_id
      t.integer   :parent_id
      t.integer   :resource_id
      t.string    :resource_type
      t.timestamps :null => true
    end
    add_index :postings, :user_id
    add_index :postings, :parent_id
    add_index :postings, [ :resource_id, :resource_type ]
  end

  def self.down
    drop_table :postings rescue nil
  end
end
