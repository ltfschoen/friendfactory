class Asset::Text < Asset::Base
  def to_s
    self.value
  end
end