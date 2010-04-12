class CreateWalls < ActiveRecord::Migration
  def self.up
    create_table :walls do |t|
      t.string  :type      
      t.string  :title
      t.string  :description
      t.integer :owner_id
      t.timestamps
    end
  end

  def self.down
    drop_table :walls rescue nil
  end
end
