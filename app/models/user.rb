class User < ActiveRecord::Base
  
  EmailPattern = /(\S+)@(\S+)/

  include AASM
  
  aasm_column        :status
  aasm_initial_state :welcomed
  aasm_state         :welcomed
  
  validates_format_of :email, :with => EmailPattern
  
end