class Wave::Conversation < Wave::Base

  has_and_belongs_to_many :messages,
      :class_name              => 'Posting::Message',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :conditions              => 'parent_id is null',
      :order                   => 'created_at asc',
      :after_add               => :publish_to_inbox do
    def published
      where(:state => :published)
    end
  end

  alias :recipient :resource
  alias :receiver  :resource

  private
    
  def publish_to_inbox(message)
    inbox = user.inbox(message.site)
    unless inbox.nil? || inbox.wave_ids.include?(id)
      inbox.waves << self
      publish! unless published?
    end
  end

end