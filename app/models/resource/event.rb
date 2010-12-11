module Resource
  class Event < ActiveRecord::Base
    has_one :event, :as => :resource, :class_name => 'Wave::Event'    
    def start_date=(date)
      write_attribute(:start_date, Date.strptime(date, '%m/%d/%Y'))
    end
  end
end
