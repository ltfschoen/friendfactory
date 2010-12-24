class Wave::Event < Wave::Base  
  extend Forwardable

  attr_accessible :promoter_name, :description,
      :start_date, :start_time, :end_date, :url, :location, :body

  def_delegators :event_info,
      :start_date,  :start_date=,
      :end_date,    :end_date=,
      :url,         :url=,
      :location,    :location=,
      :body,        :body=

  validates_presence_of :user_id, :promoter_name, :description
  
  attr_readonly :user_id

  acts_as_taggable
  acts_as_slugable :source_column => :description, :slug_column => :slug

  has_many :profiles, :through => :invitations

  after_save do |event|
    event.event_info.save
    wave = Wave::Base.find_by_slug(Wave::CommunitiesController::DefaultWaveSlug)
    if wave
      posting = Posting::WaveProxy.new(:user_id => event.user_id)
      posting.resource = event
      posting.save    
      wave.postings << posting
    end
    true
  end

  def initialize(attrs={})
    start_date = attrs.delete('start_date')
    if start_date
      start_date += " #{attrs['start_time(4i)']}:#{attrs['start_time(5i)']}" 
      attrs.delete('start_time(4i)')
      attrs.delete('start_time(5i)')
    end
    super(attrs.merge(:start_date => start_date))
  end

  def promoter_name=(name)
    self.topic = name
  end
  
  def promoter_name
    self.topic
  end
  
  def event_info
    self.resource ||= Resource::Event.new
  end
  
  def start_time=(start_time)
  end
  
end
