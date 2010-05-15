class UserSession < Authlogic::Session::Base
  
  Timeout = 24.hours
  logout_on_timeout(true)
  
end
