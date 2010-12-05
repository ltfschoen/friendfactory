class Posting::Message < Posting::Base

  attr_accessible :subject, :body, :user_id, :receiver_id
  attr_readonly :user_id

  alias_attribute :sender, :user

  attr_accessor :receiver_id # user_id
  
  has_many :notifications
  
  # TODO validates_presence_of :receiver_id

  # publish_to :wave => Wave::Conversation  
  after_create do |posting|
    wave = find_or_create_recipient_wave(posting)
    wave.postings << posting if wave
    true
  end  

  # # # # # #
  
  def read?
    !!read_at
  end
  
  def recipient_for(user)
    [ sender, receiver ].detect{ |recipient| recipient != user }
  end

  def direction_for(user)
    sender == user ? 'from' : 'to'
  end

  def latest_reply
    leaf = self.children.last
    leaf.nil? ? self : leaf.latest_reply
  end

  def to_s
    "{ :id => #{self.id}, :sender => #{sender.to_s}, :receiver => #{receiver.to_s} :subject => '#{subject}' }"
  end
  
  private
  
  def reply_subject(subject = nil)
    subject || self.subject && self.subject !~ /^Re:\s/ ? 'Re: ' + self.subject : self.subject
  end
  
  def find_or_create_recipient_wave(posting)
    if posting.present?
      receiver = User.find_by_id(posting.receiver_id)
      if receiver.present? && (receiver != posting.sender)
        receiver.conversation.with(posting.sender) || receiver.create_conversation_with(posting.sender)
      end
    end
  end
      
end
