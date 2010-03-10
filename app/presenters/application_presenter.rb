require 'forwardable'

class ApplicationPresenter
  extend Forwardable
  
  def initialize(params = nil)
    params.each_pair do |attribute, value|
      instance_variable_set('@' << attribute.to_s, value)
    end unless params.nil?
  end  
    
end
