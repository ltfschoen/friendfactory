class Wave::Conversation < Wave::Base

  has_and_belongs_to_many :messages,
      :class_name              => 'Posting::Message',
      :foreign_key             => 'wave_id',
      :association_foreign_key => 'posting_id',
      :join_table              => 'postings_waves',
      :conditions              => 'parent_id is null',
      :order                   => 'created_at asc',
      :after_add               => :add_conversation_to_inbox do
    def published
      where(:state => :published)
    end
  end

  alias :recipient :resource

  private
  
  def add_conversation_to_inbox(message)
    inbox = self.user.inbox
    unless inbox.nil? || inbox.wave_ids.include?(self.id)
      inbox.waves << self
    end
  end

end