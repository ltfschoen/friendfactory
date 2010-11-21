class MoveUserInfoToProfiles < ActiveRecord::Migration
  def self.up 
    cnt = 0   
    UserInfo.all.each do |user_info|
      profile = Wave::Profile.find_by_user_id(user_info.user_id)      
      if profile
        profile.resource = user_info
        profile.save
        print "#{user_info.id} "
      else
        print "**#{user_info.id}** "
      end
      STDOUT.flush
      cnt += 1
    end
    
    remove_column :user_info, :user_id
    puts "Done" if cnt > 0
  end

  def self.down
  end
end
