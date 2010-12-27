class UserSession < Authlogic::Session::Base  
  
  Timeout = 10.minutes
  remember_me_for 2.weeks
  # logout_on_timeout true
  
  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

end
