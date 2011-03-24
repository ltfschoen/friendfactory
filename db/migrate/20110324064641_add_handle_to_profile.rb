class AddHandleToProfile < ActiveRecord::Migration
  def self.up
    add_column :user_info, :handle, :string
    add_column :user_info, :first_name, :string
    add_column :user_info, :last_name, :string
    
    Rake::Task[:'ff:fix:profile_handles'].invoke
    
    say 'Please remove users columns manually'
    say 'drop_column :user, :handle', true
    say 'drop_column :user, :first_name', true
    say 'drop_column :user, :last_name', true
  end

  def self.down
    drop_column :user_info, :handle
    drop_column :user_info, :first_name
    drop_column :user_info, :last_name    
  end
end
