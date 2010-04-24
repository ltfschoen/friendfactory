class UserObserver < ActiveRecord::Observer

  def after_create(user)
    Wave::Profile::create(:user => user)
  end
  
  def after_save(user)
    Wave::Profile::create(:user => user) if user.profile.nil?
  end
  
end
