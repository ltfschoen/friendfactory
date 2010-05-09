class CreateWaves < ActiveRecord::Migration
  def self.up
    create_table :waves do |t|
      t.string    :type
      t.string    :slug
      t.integer   :user_id
      t.string    :topic
      t.string    :description
      t.timestamps
    end
  end

  def self.down
    drop_table :waves rescue nil
  end
end
