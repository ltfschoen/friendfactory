class Wave::Conversation < Wave::Base

  scope :unread,
      joins('LEFT OUTER JOIN bookmarks ON "postings"."id" = "bookmarks"."wave_id" AND "postings"."user_id" = "bookmarks"."user_id"').
      where('("postings"."updated_at" > "bookmarks"."read_at") OR ("bookmarks"."read_at" IS NULL)')

  scope :chatty, where('"postings"."postings_count" > 0')
  scope :recipient, lambda { |user| where resource_id: user.id }

  belongs_to :recipient,
      :class_name  => 'Personage',
      :foreign_key => 'resource_id'

  alias_attribute :recipient_id, :resource_id

  subscribable :conversation, :user

  ###

  def messages
    postings.type(Posting::Message).scoped
  end

  def publish_posting_to_waves(posting)
    if (user_id != recipient_id)
      recipient.find_or_create_conversation_with(user, recipient.site).touch_and_publish!
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
    self
  end

  private

  def bookmark
    @bookmark ||= bookmarks.find_or_create_by_user_id(self.user_id)
  end

end
