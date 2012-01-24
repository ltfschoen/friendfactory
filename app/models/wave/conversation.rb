class Wave::Conversation < Wave::Base

  scope :unread,
      joins('LEFT OUTER JOIN bookmarks ON `waves`.`id` = `bookmarks`.`wave_id` AND `waves`.`user_id` = `bookmarks`.`user_id`').
      where('(`waves`.`updated_at` > `bookmarks`.`read_at`) OR (`bookmarks`.`read_at` IS NULL)')

  scope :chatty, where('`waves`.`postings_count` > 0')

  belongs_to :recipient,
      :class_name => 'Personage',
      :foreign_key => 'resource_id'

  def messages
    postings.type(Posting::Message).scoped
  end

  def publish_posting_to_waves(posting)
    if (posting.receiver.id != posting.sender_id) && wave = posting.receiver.find_or_create_conversation_with(posting.sender, posting.site)
      wave.touch_and_publish! && wave
    end
  end

  def mark_as_read
    bookmark.read
    self
  end

  alias :read  :mark_as_read
  alias :read! :mark_as_read

  def read_at
    bookmark.read_at
  end

  def last_read_at
    bookmark.last_read_at
  end

  def unread?
    last_read_at.nil? || (last_read_at < updated_at)
  end

  def touch_and_publish!
    published? ? touch : publish!
  end

  private

  def bookmark
    @bookmark ||= bookmarks.find_or_create_by_user_id(self.user_id)
  end

end