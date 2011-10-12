class Stylesheet < ActiveRecord::Base
  attr_accessible :controller_name, :css
  has_one :site
end
