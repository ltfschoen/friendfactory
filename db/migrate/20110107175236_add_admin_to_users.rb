class AddAdminToUsers < ActiveRecord::Migration
  def self.up
    # add_column :users, :admin, :boolean, :default => false
    add_column :users, :admin, :integer
    # User.update_all :admin => false
  end

  def self.down
    remove_column :users, :admin rescue nil
  end
end
