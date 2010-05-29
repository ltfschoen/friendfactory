require 'pusher'

class Broadcast
  
  Pusher.app_id = '990'
  Pusher.key = '064cfff6a7f7e44b07ae'
  Pusher.secret = 'bea582cd929821f3f0f0'
  
  class << self  
    def user_online(domain, user)
      # avatar = user.profile.avatar
      # Pusher['wave'].trigger('user-online', { :full_name => user.full_name, :avatar => { :id => avatar.try(:id), :file_name => avatar.try(:image_file_name) }})            
      Pusher['wave'].trigger('user-online', { :full_name => user.full_name })            
    end
  
    def user_offline(domain, user)
      Pusher['wave'].trigger('user-offline', { :full_name => user.full_name })
    end
  
    def user_create(domain, user)
      Pusher['wave'].trigger('user-register', { :full_name => user.full_name })      
    end  
  end
end