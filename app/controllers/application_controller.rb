class ApplicationController < ActionController::Base
  
  helper :all  
  layout 'friskyhands'
  
  filter_parameter_logging :password  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details  
  
end
