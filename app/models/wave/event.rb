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
  
  acts_as_taggable
  acts_as_slugable :source_column => :description, :slug_column => :slug

  validates_presence_of :user_id, :promoter_name, :description

  before_save do |event|
    self.tag_list = scrub_tag(event.location.city) if event.location.present?
  end

  after_save do |event|
    if wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
      posting = Posting::WaveProxy.new(:user_id => event.user_id)
      posting.resource = event
      wave.postings << posting
      posting.publish!
    end
  end

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
  
end
