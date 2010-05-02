class Posting::BaseObserver < ActiveRecord::Observer
  
  def before_save(posting)
    posting.user = UserSession.find.record if Authlogic::Session::Base.activated?
  end
  
end
