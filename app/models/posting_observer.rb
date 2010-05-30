class PostingObserver < ActiveRecord::Observer
  
  observe Posting::Base
  
  def before_validation_on_create(posting)
    posting.user = UserSession.find.record if Authlogic::Session::Base.activated?
  end  
  
end
