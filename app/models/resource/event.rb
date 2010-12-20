module Resource
  class Event < ActiveRecord::Base    
    
    has_one :event, :as => :resource, :class_name => 'Wave::Event'
    belongs_to :location
    
    def start_date=(date)      
      if date.present?
        write_attribute(:start_date, DateTime.parse(date)) rescue nil
      end
    end    

    def end_date=(date)
      if date.present?
        write_attribute(:end_date, DateTime.parse(date)) rescue nil
      end
    end
    
    def location=(attrs)
      if attrs.is_a?(Hash)
        build_location(attrs)
      end      
    end
            
  end
end
