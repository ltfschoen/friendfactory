class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations, :force => true do |t|
      t.string      :name
      t.string      :address
      t.string      :street
      t.string      :locality
      t.string      :city
      t.string      :country
      t.string      :post_code
      t.integer     :latitute
      t.integer     :longitude
      t.timestamps
    end
  end

  def self.down
    drop_table :locations rescue nil
  end
end
