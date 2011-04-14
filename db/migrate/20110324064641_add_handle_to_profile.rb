class AddHandleToProfile < ActiveRecord::Migration
  def self.up
    add_column :user_info, :handle, :string
    add_column :user_info, :first_name, :string
    add_column :user_info, :last_name, :string
    
    UserInfo.reset_column_information

    say "Invoking ff:fix:profile_handles"
    Rake::Task[:'ff:fix:profile_handles'].invoke
    
    say 'Please remove users columns manually'
    say 'remove_column :user, :handle', true
    say 'remove_column :user, :first_name', true
    say 'remove_column :user, :last_name', true

    say "Invoking ff:fix:admin_tags"
    Rake::Task[:'ff:fix:admin_tags'].invoke
  end

  def self.down
    remove_column :user_info, :handle
    remove_column :user_info, :first_name
    remove_column :user_info, :last_name    
  end
end
