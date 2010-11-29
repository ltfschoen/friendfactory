class Wave::Event < Wave::Base

  attr_accessible :promoter_name, :description
  
  acts_as_taggable

  acts_as_slugable :source_column => :description, :slug_column => :slug

  def promoter_name=(name)
    self.topic = name
  end
  
  def promoter_name
    self.topic
  end

end
