class AddHandleToProfile < ActiveRecord::Migration
  def self.up
    add_column :user_info, :handle, :string
    add_column :user_info, :first_name, :string
    add_column :user_info, :last_name, :string

    # UserInfo.reset_column_information

    say "Invoking ff:fix:profile_handles"
    # Rake::Task[:'ff:fix:profile_handles'].invoke

    say 'Remove users columns'
    say 'remove_column :user, :handle', true
    say 'remove_column :user, :first_name', true
    say 'remove_column :user, :last_name', true

    say "Move user_info tags to profile tags"
    say "ff:fix:profile_tags", true
  end

  def self.down
    remove_column :user_info, :handle
    remove_column :user_info, :first_name
    remove_column :user_info, :last_name
  end
end
