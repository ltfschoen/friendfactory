class Posting::Message < Posting::Base

  attr_accessor :receiver
  attr_accessor :site

  alias_attribute :sender, :user
  alias_attribute :sender_id, :user_id

  attr_accessible :subject, :body
  attr_readonly :user

  validates_presence_of :user, :receiver, :site
  
  has_many :notifications
  
  after_create do |posting|
    if wave = find_or_create_recipient_wave(posting)
      wave.messages << posting
    end
  end

  def receiver
    @receiver || waves.where('user_id <> ?', user_id).limit(1).first.try(:user)
  end
      
  private
  
  def find_or_create_recipient_wave(posting)
    if posting.receiver != posting.sender
      posting.receiver.conversation.with(posting.sender, posting.site) || posting.receiver.create_conversation_with(posting.sender, posting.site)
    end
  end
        
end
