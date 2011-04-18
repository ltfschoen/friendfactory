require 'tag_scrubber'

class Wave::Event < Wave::Base  

  extend Forwardable
  include TagScrubber
  
  attr_readonly :user_id
  attr_accessible :promoter_name,
      :description,
      :start_date, :start_time,
      :end_date,
      :url,
      :location,
      :body

  def_delegators :event_resource,
      :start_date, :start_date=,
      :end_date, :end_date=,
      :url, :url=,
      :location, :location=,
      :body, :body=

  alias_attribute :promoter_name, :topic
  
  acts_as_slugable :source_column => :description, :slug_column => :slug

  validates_presence_of :user_id, :promoter_name, :description
  
  def initialize(attrs={})    
    if start_date = attrs.delete('start_date')
      start_date += " #{attrs['start_time(4i)']}:#{attrs['start_time(5i)']}" 
      attrs.delete('start_time(4i)')
      attrs.delete('start_time(5i)')
    end
    super(attrs.merge(:start_date => start_date))
  end
  
  def event_resource
    self.resource ||= Resource::Event.new
  end
  
  def start_time=(start_time)
    # TODO
  end

  def set_tag_list
    if location.present? && location.city.present?
      super(scrub_tag(location.city))
    end
  end
  
end
