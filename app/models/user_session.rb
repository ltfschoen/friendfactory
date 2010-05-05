class UserSession < Authlogic::Session::Base
  
  Timeout = 30.minutes
  logout_on_timeout(true)
  
end