class Wave::Conversation < Wave::Base

  scope :unread,
      joins('LEFT OUTER JOIN bookmarks ON `waves`.`id` = `bookmarks`.`wave_id` AND `waves`.`user_id` = `bookmarks`.`user_id`').
      where('(`waves`.`updated_at` > `bookmarks`.`read_at`) OR (`bookmarks`.`read_at` IS NULL)')

  scope :chatty,
      select('DISTINCT `waves`.*').
      joins('LEFT OUTER JOIN `publications` on `waves`.`id` = `publications`.`wave_id`').
      where('`publications`.`resource_id` IS NOT NULL')

  alias :recipient :resource

  def messages
    postings.type(Posting::Message).scoped
  end

  def add_posting_to_other_waves(posting)
    if (posting.receiver_id != posting.sender_id) && (wave = posting.receiver.conversation_with(posting.sender, posting.site))
      wave.postings << posting
      wave.touch
    end
  end

  def read
    bookmark.read
    self
  end

  alias :read! :read

  def read_at
    bookmark.read_at
  end

  def last_read_at
    bookmark.last_read_at
  end

  def unread?
    last_read_at.nil? || (last_read_at < updated_at)
  end

  def touch
    published? ? super : publish!
  end

  private

  def bookmark
    @bookmark ||= bookmarks.find_or_create_by_user_id(self.user_id)
  end

end