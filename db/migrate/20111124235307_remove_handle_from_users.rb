class RemoveHandleFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :handle, :first_name, :last_name, :slug, :dob
  end

  def self.down
    add_column :users, :handle, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :slug, :string
    add_column :users, :dob, :date
  end
end
