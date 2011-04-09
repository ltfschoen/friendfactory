class AddIndexesToUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :email, :unique => true
    add_index :user_info, :handle
    add_index :user_info, :first_name
  end

  def self.down
    remove_index :users, :email
    remove_index :user_info, :handle
    remove_index :user_info, :first_name
  end
end
