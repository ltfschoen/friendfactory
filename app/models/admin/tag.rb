class Admin::Tag < ActiveRecord::Base
  
  attr_accessible :taggable_type, :defective, :corrected
  validates_presence_of :taggable_type, :defective
  
  def self.refresh_all
    ActsAsTaggableOn::Tag.delete_all
    ActsAsTaggableOn::Tagging.delete_all
    Wave::Base.type(Wave::Profile, Wave::Event).each do |wave|
      wave.sites.each do |site|
        if wave.respond_to?(:set_tag_list_on)
          wave.set_tag_list_on!(site)
        end
      end
    end
    true
  end
  
end
