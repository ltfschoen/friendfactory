class AddEmailableToUsers < ActiveRecord::Migration
  def self.up
    # add_column :users, :emailable, :boolean, :default => true
    add_column :users, :emailable, :integer
    # User.update_all :emailable => true
  end

  def self.down
    remove_column :users, :emailable rescue nil
  end
end
