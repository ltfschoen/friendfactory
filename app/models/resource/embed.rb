class Resource::Embed < ActiveRecord::Base
  self.inheritance_column = nil
  alias_attribute :url, :body
  alias_attribute :html, :body
end
