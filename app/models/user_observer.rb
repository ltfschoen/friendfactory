class UserObserver < ActiveRecord::Observer
  
  def after_save(user)
    Wave::Profile::create(:user => user) if user.profile.nil?
    UserInfo.create(:user => user) if user.info.nil?
  end
  
end
