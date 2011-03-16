class Site < ActiveRecord::Base  

  validates_presence_of :name
  
  def to_s
    name
  end
  
  def layout
    name
  end

end
