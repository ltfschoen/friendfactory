class AddSiteToLaunchUsers < ActiveRecord::Migration
  def self.up
    add_column :launch_users, :site, :string
  end

  def self.down
    remove_column :launch_users, :site
  end
end
