class FriskyhandsSite < ApplicationSite  
  def name
    @name ||= "friskyhands"
  end
  
  def layout
    name
  end  
end