class Posting::Message < Posting::Base

  attr_accessor :site
  attr_writer   :receiver

  alias_attribute :sender, :user
  alias_attribute :sender_id, :user_id

  attr_accessible :subject, :body

  validates_presence_of :user
  validates_presence_of :receiver, :site, :on => :create

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
    waves(true).where('`waves`.`user_id` <> ?', user_id).limit(1).first
  end

  def receiver_id
    @receiver.id
  end

end
