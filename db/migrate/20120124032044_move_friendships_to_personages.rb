class MoveFriendshipsToPersonages < ActiveRecord::Migration

  def self.up
    remove_index  :friendships, [ :type, :profile_id, :friend_id ]
    rename_column :friendships, :profile_id, :user_id
    add_column    :friendships, :state, :string

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
    remove_column :friendships, :state
    add_index     :friendships, [ :type, :profile_id, :friend_id ], :unique => true
    ## Non-reversable data migration!
  end

  def self.associate_friendships_to_persoanges
    Friendship::Base.all.each do |friendship|
      sender_profile_id = friendship[:user_id]
      friend_profile_id = friendship[:friend_id]

      wave = Wave::Base.find(sender_profile_id)
      friendship[:user_id] = wave[:user_id]

      wave = Wave::Base.find(friend_profile_id)
      friendship[:friend_id] = wave[:user_id]

      friendship.save!
    end
  end

end
