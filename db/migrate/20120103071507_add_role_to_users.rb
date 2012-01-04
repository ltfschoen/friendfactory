class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role_id, :integer

    User.reset_column_information
    ActiveRecord::Base.record_timestamps = false

    User.transaction do
      say_with_time 'initializing role for users' do
        if user_role = Role.find_by_name('user')
          User.update_all({ :role_id => user_role.id }, { :admin => false })
        end
      end

      say_with_time 'initializing role for administrators' do
        if admin_role = Role.find_by_name('administrator')
          User.update_all({ :role_id => admin_role.id }, { :admin => true })
        end
      end
    end

    remove_column :users, :admin
  end

  def self.down
    add_column :users, :admin, :boolean rescue nil
    User.reset_column_information

    say_with_time 'initializing admin for administrators' do
      Role.transaction do
        Role.where(:name => 'administrator').users.each do |user|
          user.admin = true
          user.save!
        end
      end
    end

    remove_column :users, :role_id rescue nil
  end
end
