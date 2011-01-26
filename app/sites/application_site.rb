class ApplicationSite    
  def name
    "default"
  end

  def name=(name)
    @name = name
  end    
  
  def to_s
    name
  end
end