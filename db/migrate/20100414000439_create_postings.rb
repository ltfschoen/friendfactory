class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string    :type
      t.string    :slug
      t.integer   :user_id
      t.integer   :wave_id
      t.integer   :parent_id
      t.timestamps
    end    
    add_index :postings, :user_id
    add_index :postings, :parent_id
  end

  def self.down
    drop_table :postings rescue nil
  end
end
