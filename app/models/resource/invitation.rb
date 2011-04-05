module Resource
  class Invitation < ActiveRecord::Base
    has_one :invitation, :as => :resource, :class_name => 'Posting::Invitation'
  end
end

