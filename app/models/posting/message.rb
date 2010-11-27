class Posting::Message < Posting::Base

  attr_accessible :subject, :body, :user_id, :receiver_id
  attr_readonly :user_id

  alias_attribute :sender, :user

  # receiver_id is a User
  attr_accessor :receiver_id
    
  has_many :notifications
  
  # TODO validates_presence_of :receiver_id

  publish_to :wave => Wave::Conversation

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
      
end
