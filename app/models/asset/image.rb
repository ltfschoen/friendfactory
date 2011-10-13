class Asset::Image < Asset::Base
  has_attached_file :asset, :styles => { :thumb => '100x100' }
  def to_s
    "$#{self.name}:'#{self.url(:original)}';" if asset.present?
  end
  def url(style = :original)
    asset.url(style)
  end
end
