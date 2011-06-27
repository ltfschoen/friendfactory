class Wave::Conversation < Wave::Base

  has_many :messages,
      :through     => :publications,
      :source      => :resource,
      :source_type => 'Posting::Base',
      :conditions  => { :parent_id => nil, :type => Posting::Message },
      :order       => 'created_at asc',
      :after_add   => :publish_to_inbox do
    def received
      where('`postings`.`user_id` <> ?', proxy_owner.user_id)
    end
  end
  
  scope :unread,
      joins('LEFT OUTER JOIN bookmarks ON `waves`.`id` = `bookmarks`.`wave_id`').
      where('(`waves`.`updated_at` > `bookmarks`.`read_at`) OR (`bookmarks`.`read_at` IS NULL)')

  scope :chatty,
      select('DISTINCT `waves`.*').
      joins('LEFT OUTER JOIN `publications` on `waves`.`id` = `publications`.`wave_id`').
      where('`publications`.`resource_id` is not null')

  alias :recipient :resource

  def read
    bookmark.read
    self
  end
  
  def read_at
    bookmark.read_at
  end
  
  def last_read_at
    bookmark.last_read_at
  end

  def unread?
    last_read_at.nil? || (last_read_at < updated_at)
  end

  def unread_messages_count
    last_read_at.nil? ? messages.received.published.count : messages.received.published.since(last_read_at).count
  end

  private
    
  def publish_to_inbox(message)
    touch
    inbox = user.inbox(message.site)
    unless inbox.nil? || inbox.wave_ids.include?(id)
      inbox.waves << self
      publish! unless published?
    end
  end

  def bookmark
    @bookmark ||= (bookmarks.where(:user_id => user_id).order('created_at asc').limit(1).first || bookmarks.create(:user_id => user_id))
  end
  
end