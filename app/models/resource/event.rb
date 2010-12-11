module Resource
  class Event < ActiveRecord::Base
    has_one :event, :as => :resource, :class_name => 'Wave::Event'    
    def start_date=(date)
      formatted_date = Date.strptime(date, '%m/%d/%Y') rescue nil
      write_attribute(:start_date, formatted_date) 
    end
  end
end
