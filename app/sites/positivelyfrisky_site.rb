class PositivelyfriskySite < ApplicationSite  
  def name
    @name ||= "positivelyfrisky"
  end
    
  def layout
    name
  end  
end