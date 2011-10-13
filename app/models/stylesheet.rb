class Stylesheet < ActiveRecord::Base
  attr_accessible :controller_name, :css
  has_one :site
  def controller_name=(name)
    name = nil if name.blank?
    super(name)
  end
end
