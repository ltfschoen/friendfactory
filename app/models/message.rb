class Message < ActiveRecord::Base

  acts_as_tree :order => 'created_at asc'

  alias_attribute :recipient,    :receiver
  alias_attribute :recipient_id, :receiver_id

  validates_presence_of :sender_id
  validates_presence_of :receiver_id

  belongs_to :sender,   :class_name => User.name, :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => User.name, :foreign_key => 'receiver_id'

  attr_accessible :subject, :body, :receiver, :recipient, :receiver_id, :recipient_id

  named_scope :unread, :conditions => { :read_at => nil }

  def read?
    !!read_at
  end
  
end
