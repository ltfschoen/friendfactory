class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string

    User.reset_column_information

    say_with_time 'initializing role for administrators' do
      User.update_all({ :role => 'user' }, { :admin => false })
      User.update_all({ :role => 'administrator' }, { :admin => true })
    end

    add_index :users, :role

    remove_column :users, :admin
  end

  def self.down
    add_column :users, :admin, :boolean rescue nil

    User.reset_column_information

    say_with_time 'initializing admin for administrators' do
      User.update_all({ :admin => true }, { :role => 'administrator' })
    end

    remove_column :users, :role rescue nil
  end
end
