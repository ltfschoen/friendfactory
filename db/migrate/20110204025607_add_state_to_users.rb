class AddStateToUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :status, :state
    # User.update_all(:state => :enabled)
  end

  def self.down
    rename_column :users, :state, :status
  end
end
