module Resource
  class Event < ActiveRecord::Base
    has_one :event, :as => :resource, :class_name => 'Wave::Event'
  end
end
