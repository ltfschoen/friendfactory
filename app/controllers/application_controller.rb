class ApplicationController < ActionController::Base
  
  SiteName = 'friskyhands'
  
  helper :all    
  filter_parameter_logging :password  
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details  
  
end
