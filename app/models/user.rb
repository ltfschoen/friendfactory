class User < ActiveRecord::Base
  
  include AASM
  
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed
  
  acts_as_authentic do |config|
    config.logged_in_timeout = 30.minutes
  end

  def require_password?
    true
  end
  
end
