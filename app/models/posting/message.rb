class Posting::Message < Posting::Base

  attr_accessible :subject, :body

  alias_attribute :sender,    :user
  alias_attribute :sender_id, :user_id

  validates_presence_of :user

  scope :sender, lambda { |user|
    where(:user_id => user[:id])
  }

  def receiver
    return @receiver if defined?(@receiver)
    if wave = receiver_wave
      wave.user
    end
  end

  def sender_wave
    waves.where(:user_id => user_id).limit(1).first
  end

  def receiver_wave
    waves(true).where('`postings`.`user_id` <> ?', user_id).limit(1).first
  end

  def receiver_id
    @receiver.id
  end

end
