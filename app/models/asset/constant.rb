class Asset::Constant < Asset::Base
  def to_s
    "$#{self.name}:#{self.value};"
  end
end
