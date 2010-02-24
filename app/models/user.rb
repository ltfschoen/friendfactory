require 'aasm'

class User < ActiveRecord::Base
  
  include AASM
  
  aasm_column :status
  aasm_initial_state :interested
  
  aasm_state :interested
  
end