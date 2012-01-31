class MoveFriendshipsToPersonages < ActiveRecord::Migration

  def self.up
    remove_index  :friendships, [ :type, :profile_id, :friend_id ]
    rename_column :friendships, :profile_id, :user_id

    Friendship::Base.reset_column_information
    Friendship::Base.record_timestamps = false
    
    ActiveRecord::Base.transaction do
      say_with_time 'move friendships from profiles to personages' do
        associate_friendships_to_persoanges
      end
    end

    Friendship::Base.record_timestamps = true
    add_index :friendships, [ :type, :user_id, :friend_id ], :unique => true
  end

  def self.down
    remove_index  :friendships, [ :type, :user_id, :friend_id ]
    rename_column :friendships, :user_id, :profile_id
    add_index     :friendships, [ :type, :profile_id, :friend_id ], :unique => true
    ## Non-reversable data migration!
  end

  def self.associate_friendships_to_persoanges
    Friendship::Base.all.each do |friendship|
      user_profile_id = friendship[:user_id]
      friend_profile_id = friendship[:friend_id]

      user_profile = Wave::Base.find(user_profile_id)
      friend_profile = Wave::Base.find(friend_profile_id)

      if user_profile && friend_profile
        friendship[:user_id] = user_profile[:user_id]
        friendship[:friend_id] = friend_profile[:user_id]
        friendship.save!
      end
    end
  end

end
