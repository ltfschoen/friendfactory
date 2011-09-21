class Asset::Base < ActiveRecord::Base
  set_table_name :assets
  belongs_to :site  
  alias_attribute :value, :asset_file_name
  alias :to_s :value  
  scope :type, lambda { |*types| where('`assets`.`type` IN (?)', types.map(&:to_s)) }
end