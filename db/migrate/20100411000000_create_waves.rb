class CreateWaves < ActiveRecord::Migration
  def self.up
    create_table :waves, :force => true do |t|
      t.string    :type
      t.string    :slug
      t.integer   :user_id
      t.string    :topic
      t.string    :description
      t.timestamps :null => true
    end
    add_index :waves, :type
    add_index :waves, :user_id
  end

  def self.down
    drop_table :waves rescue nil
  end
end
