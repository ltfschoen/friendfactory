class Asset::Base < ActiveRecord::Base
  self.table_name = "assets"
  belongs_to :site
  alias_attribute :value, :asset_file_name
  scope :type, lambda { |*types| where('"assets"."type" IN (?)', types.map(&:to_s)) }
end
