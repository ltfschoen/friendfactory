class CreateLaunchUsers < ActiveRecord::Migration
  def self.up
    create_table :launch_users do |t|
      t.string   :email
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :launch_users
  end
end
