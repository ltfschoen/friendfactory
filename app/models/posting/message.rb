class Posting::Message < Posting::Base

  attr_writer :receiver
  attr_accessor :site

  alias_attribute :sender, :user
  alias_attribute :sender_id, :user_id

  attr_accessible :subject, :body, :sender, :receiver, :site
  
  attr_readonly :user, :receiver, :site
  
  has_many :notifications
  
  validates_presence_of :user, :receiver, :site

  after_create do |posting|
    posting.publish!
    if wave = find_or_create_recipient_wave(posting)
      wave.messages << posting
      wave.touch
    end
  end
  
  after_commit do |posting|
    if !posting.receiver.online? && posting.receiver.emailable?
      MessagesMailer.new_message_notification(posting).deliver
    end
  end

  # def read?
  #   !!read_at
  # end

  def receiver
    if defined? @receiver
      User.find_by_id(@receiver.id)
    else
      waves.where('user_id <> ?', user_id).limit(1).first.try(:user)
    end
  end
      
  def to_s
    "{ :id => #{self.id}, :sender => #{sender.to_s}, :receiver => #{receiver.to_s} :subject => '#{subject}' }"
  end
    
  private
  
  def find_or_create_recipient_wave(posting)
    if posting.receiver != posting.sender
      posting.receiver.conversation.with(posting.sender, posting.site) || posting.receiver.create_conversation_with(posting.sender, posting.site)
    end
  end
        
end
