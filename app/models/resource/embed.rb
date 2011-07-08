class Resource::Embed < ActiveRecord::Base
  set_inheritance_column nil
  alias_attribute :url, :body
  alias_attribute :html, :body
end
