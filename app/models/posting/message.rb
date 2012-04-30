class Posting::Message < Posting::Base

  attr_accessible :subject, :body

  alias_attribute :sender,    :user
  alias_attribute :sender_id, :user_id

  validates_presence_of :user

  scope :sender, lambda { |user|
    where(:user_id => user[:id])
  }

  def receiver
    @receiver ||= begin
      sender_wave.recipient
    end
  end

  def sender_wave(reload = false)
    @sender_wave = nil if reload
    @sender_wave ||= begin
      waves(reload).type(Wave::Conversation).find_by_user_id(user_id)
    end
  end

  def receiver_wave(reload = false)
    @receiver_wave = nil if reload
    @receiver_wave ||= begin
      waves(reload).type(Wave::Conversation).find_by_user_id(receiver_id)
    end
  end

  def receiver_id
    sender_wave.recipient_id
  end

end
