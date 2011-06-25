class Wave::Conversation < Wave::Base

  has_many :messages,
      :through     => :publications,
      :source      => :resource,
      :source_type => 'Posting::Base',
      :conditions  => { :parent_id => nil, :type => Posting::Message },
      :order       => 'created_at asc',
      :after_add   => :publish_to_inbox do
    def published
      where(:state => :published)
    end
  end

  alias :recipient :resource

  private
    
  def publish_to_inbox(message)
    touch
    inbox = user.inbox(message.site)
    unless inbox.nil? || inbox.wave_ids.include?(id)
      inbox.waves << self
      publish! unless published?
    end
  end

end