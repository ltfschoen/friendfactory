class User < ActiveRecord::Base
  
  # EmailPattern = /(\S+)@(\S+)/

  include AASM
  
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed
  
  # validates_format_of :email, :with => EmailPattern
  
  acts_as_authentic do |config|
    config.validate_login_field = false
    config.logged_in_timeout = 30.minutes
    config.validate_password_field = false
    config.require_password_confirmation = false
  end

  def require_password?
    false
  end
  
end
