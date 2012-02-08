class Asset::Constant < Asset::Base

  def to_s
    "$#{self.name}:#{self.value};"
  end

  class << self
    def [](name, site)
      where(:site_id => site.id).find_by_name(name).try(:value)
    end
  end

end
