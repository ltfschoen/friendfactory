class Message < ActiveRecord::Base

  acts_as_tree :order => 'created_at asc'

  alias_attribute :recipient,    :receiver
  alias_attribute :recipient_id, :receiver_id

  validates_presence_of :sender
  validates_presence_of :receiver

  belongs_to :sender,   :class_name => User.name, :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => User.name, :foreign_key => 'receiver_id'

  attr_accessible :sender, :receiver, :recipient, :subject, :body
  
  named_scope :unread, :conditions => { :read_at => nil }

  def read?
    !!read_at
  end
  
  def reply(attrs = {})
    # subject = attrs[:subject] || self.subject && self.subject !~ /^Re:\s/ ? 'Re: ' + self.subject : self.subject
    attrs.merge!(:sender => self.receiver, :receiver => self.sender, :subject => subject)
    self.children.create(attrs)
  end
  
  def to_s
    "{ :id => #{self.id}, :sender => #{sender.to_s}, :receiver => #{receiver.to_s} :subject => '#{subject}' }"
  end
      
end
