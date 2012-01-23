class AddGeocodeToPlaces < ActiveRecord::Migration
  def self.up
    add_column :personas, :address,           :string
    add_column :personas, :subpremise,        :string
    add_column :personas, :street_number,     :string
    add_column :personas, :street,            :string
    add_column :personas, :neighborhood,      :string
    add_column :personas, :sublocality,       :string
    add_column :personas, :locality,          :string
    add_column :personas, :city,              :string
    add_column :personas, :abbreviated_state, :string
    add_column :personas, :state,             :string
    add_column :personas, :country,           :string
    add_column :personas, :post_code,         :string
    add_column :personas, :lat, :decimal, :precision => 10, :scale => 7
    add_column :personas, :lng, :decimal, :precision => 10, :scale => 7
  end

  def self.down
    remove_column :personas, :address
    remove_column :personas, :subpremise
    remove_column :personas, :street_number
    remove_column :personas, :street
    remove_column :personas, :neighborhood
    remove_column :personas, :sublocality
    remove_column :personas, :locality
    remove_column :personas, :city
    remove_column :personas, :state
    remove_column :personas, :country
    remove_column :personas, :post_code
    remove_column :personas, :lat
    remove_column :personas, :lng
  end
end
