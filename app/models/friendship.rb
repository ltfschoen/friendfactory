class Friendship < ActiveRecord::Base
    
  belongs_to :user
  belongs_to :friend,  :class_name => 'User'
  has_one    :posting, :class_name => 'Posting::Base', :as => :resource
  
  validates_presence_of :user
  validates_presence_of :friend
  
  after_create do |friendship|
    
    # TODO Setting the user here should not be required, since it is
    # set in the PostingObserver. However, if running from the console,
    # there won't be a user logged in, and so the observer will fail.
    # Hence, hardwire the user here (for the time being).
    
    posting = Posting::Buddy.create(:user => friendship.user, :resource => friendship)
    posting.waves << friendship.user.profile
  end
  
end
