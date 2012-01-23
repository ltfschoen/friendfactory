class Admin::Tag < ActiveRecord::Base

  attr_accessible \
      :taggable_type,
      :defective,
      :corrected

  validates_presence_of \
      :taggable_type,
      :defective

  def self.refresh_all
    ActiveRecord::Base.transaction do
      delete_all
      initialize_all
    end
  end

  def self.delete_all
    ActsAsTaggableOn::Tag.delete_all
    ActsAsTaggableOn::Tagging.delete_all
  end

  def self.initialize_all
    Persona::Base.includes(:taggings).all.each do |persona|
      if location = persona.location
        persona.send(:location=, location)
        persona.save(:validate => false)
      end
    end
  end

  def self.initialize_empty
    personas = Persona::Base.includes(:taggings).all.select { |p| p.tag_list.empty? }
    personas.each do |persona|
      location = persona.location
      persona.send(:location=, location)
      persona.save(:validate => false)
    end
  end

end
