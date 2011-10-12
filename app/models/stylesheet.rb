class Stylesheet < ActiveRecord::Base
  attr_accessible :controller, :css  
  has_one :site
end
