class UserSession < Authlogic::Session::Base  
  
  InactivityTimeout = 10.minutes
  remember_me_for 4.weeks
  
  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

end
