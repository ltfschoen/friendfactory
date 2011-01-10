class Admin::Tag < ActiveRecord::Base
  attr_accessible :taggable_type, :defective, :corrected
  validates_presence_of :taggable_type, :defective
end
