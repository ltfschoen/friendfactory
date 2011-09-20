class Asset::Base < ActiveRecord::Base
  set_table_name :assets
  belongs_to :site
  scope :type, lambda { |*types| where('`assets`.`type` IN (?)', types.map(&:to_s)) }
end