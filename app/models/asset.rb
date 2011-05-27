class Asset < ActiveRecord::Base  
  belongs_to :site
  has_attached_file :asset, :styles => { :thumb => '100x100' }
end
