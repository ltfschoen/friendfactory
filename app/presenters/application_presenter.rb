require 'forwardable'

class ApplicationPresenter
  extend Forwardable
  
  def initialize(params = nil)
    params.each_pair do |attribute, value|
      self.send :"#{attribute}=", value      
    end unless params.nil?
  end
    
end
