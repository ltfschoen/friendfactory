class RefactorFriendships < ActiveRecord::Migration
  def self.up
    remove_index  :friendships, [ :type, :profile_id, :friend_id ]
    rename_column :friendships, :profile_id, :user_id
    add_column    :friendships, :state, :string

    Friendship::Base.reset_column_information

    say_with_time 'migrating friendships from profiles to personages' do
      ActiveRecord::Base.transaction do
        Friendship::Base.all.each do |friendship|
          sender_profile_id = friendship[:user_id]
          friend_profile_id = friendship[:friend_id]

          if wave = Wave::Base.find(sender_profile_id)
            friendship[:user_id] = wave[:user_id]
          end
          if wave = Wave::Base.find(friend_profile_id)
            friendship[:friend_id] = wave[:user_id]
          end

          friendship.save!
        end
      end
    end

    add_index :friendships, [ :type, :user_id, :friend_id ], :unique => true
  end

  def self.down
    rename_column :friendships, :user_id, :profile_id rescue nil
    remove_column :friendships, :state rescue nil
    ## Non-reversable data migration!
  end
end
