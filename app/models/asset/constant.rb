class Asset::Constant < Asset::Base
  alias_attribute :value, :asset_file_name
  alias :to_s :value
end
