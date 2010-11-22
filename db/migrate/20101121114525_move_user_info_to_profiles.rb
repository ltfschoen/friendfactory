class MoveUserInfoToProfiles < ActiveRecord::Migration
  def self.up 
    cnt = 0   
    UserInfo.all.each do |user_info|
      profile = Wave::Profile.find_by_user_id(user_info.user_id)
      if profile.nil?
        profile = Wave::Profile.new(:user_id => user_info.user_id)
      end
      profile.resource = user_info
      profile.save
      print "#{user_info.id} "
      STDOUT.flush
      cnt += 1
    end
    # TODO remove_column :user_info, :user_id
    puts "Done" if cnt > 0
  end

  def self.down
  end
end
