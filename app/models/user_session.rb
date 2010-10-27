class UserSession < Authlogic::Session::Base  
  
  Timeout = 24.hours
  logout_on_timeout(true)

  def to_key
     new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

end
