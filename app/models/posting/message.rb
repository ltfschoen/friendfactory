class Posting::Message < Posting::Base

  alias_attribute :sender,    :user
  alias_attribute :sender_id, :user_id

  validates_presence_of :sender
  validates_presence_of :receiver

  belongs_to :receiver, :class_name => User.class_name, :foreign_key => 'receiver_id'
  
  named_scope :unread, :conditions => { :read_at => nil }

  attr_accessible :sender, :receiver, :subject, :body

  def read?
    !!read_at
  end
  
  def messaging_with(current_user)
    [ sender, receiver ].detect{ |user| user != current_user }
  end
  
  def reply(attrs = {})
    subject = nil 
    # TODO: 2010/4/17 # subject = reply_subject(attrs[:subject])
    attrs.merge!(:sender => self.receiver, :receiver => self.sender, :subject => subject)
    self.children.create(attrs)
  end
  
  def to_s
    "{ :id => #{self.id}, :sender => #{sender.to_s}, :receiver => #{receiver.to_s} :subject => '#{subject}' }"
  end
  
  private
  
  def reply_subject(subject = nil)
    subject || self.subject && self.subject !~ /^Re:\s/ ? 'Re: ' + self.subject : self.subject
  end
      
end
