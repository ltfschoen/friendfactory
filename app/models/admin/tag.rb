class Admin::Tag < ActiveRecord::Base
  
  attr_accessible :taggable_type, :defective, :corrected
  validates_presence_of :taggable_type, :defective
  
  def self.refresh_all
    ActsAsTaggableOn::Tag.delete_all
    ActsAsTaggableOn::Tagging.delete_all    
    Wave::Base.type(Wave::Profile, Wave::Event).each { |wave| wave.save! }
  end
  
end
