module Resource
  class Event < ActiveRecord::Base    
    
    has_one :event, :as => :resource, :class_name => 'Wave::Event'
    belongs_to :location
    
    # def start_date=(date)
    #   # date  = DateTime.parse(date)
    #   # write_attribute(:start_date, date)
    # end    

    def end_date=(date)
      # formatted_date = Date.strptime(date, '%m/%d/%Y')
      # write_attribute(:end_date, formatted_date) 
    end
    
    def location=(attrs)
      build_location(attrs) if attrs.is_a?(Hash)
    end
            
  end
end
