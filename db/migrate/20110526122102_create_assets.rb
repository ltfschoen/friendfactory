class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets, :force => true do |t|
      t.string  :name
      t.integer :site_id
      t.string  :asset_file_name
      t.string  :asset_content_type
      t.integer :asset_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
