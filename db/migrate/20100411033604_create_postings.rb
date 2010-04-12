class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string  :type
      t.integer :parent_id
      t.integer :wall_id
      t.timestamps
    end
  end

  def self.down
    drop_table :postings rescue nil
  end
end
