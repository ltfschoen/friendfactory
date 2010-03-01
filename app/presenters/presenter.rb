require 'forwardable'

class Presenter
  extend Forwardable

  Site     = Struct.new(:name)
  Layout   = Struct.new(:name)
  
  SiteName = 'friskyhands'
  
  def initialize(params = {})
    params.each_pair do |attribute, value|
      self.send :"#{attribute}=", value      
    end unless params.nil?
  end
  
  def current_site
    @current_site ||= Site.new(SiteName)
  end
  
  def title
    current_site.name
  end
    
end
