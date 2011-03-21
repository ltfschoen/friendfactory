class Invitation < ActiveRecord::Base  
  validates_presence_of :code, :site_id, :sponsor_id
end
