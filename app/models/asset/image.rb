class Asset::Image < Asset::Base
  has_attached_file :asset, :styles => { :thumb => '100x100' }
  def value
    asset.present? && asset.url(:original)
  end
  alias :to_s :value
end
