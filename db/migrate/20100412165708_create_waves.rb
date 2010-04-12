class CreateWaves < ActiveRecord::Migration
  def self.up
    create_table :waves do |t|
      t.string :title
      t.string :description
      t.integer :owner_id

      t.timestamps
    end
  end

  def self.down
    drop_table :waves
  end
end
