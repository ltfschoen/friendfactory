class Posting::Message < Posting::Base

  attr_writer :receiver_id  
  attr_accessor :site

  attr_accessible :subject, :body, :receiver_id, :site
  attr_readonly :user_id

  alias_attribute :sender, :user
  
  has_many :notifications
  
  validates_presence_of :user_id, :receiver_id

  after_create do |posting|
    posting.publish!
    if wave = find_or_create_recipient_wave(posting)
      wave.messages << posting
      wave.touch
      if !posting.receiver.online? && posting.receiver.emailable?
        MessagesMailer.new_message_notification(posting).deliver
      end
    end
    true
  end

  # def read?
  #   !!read_at
  # end

  def receiver
    if @receiver_id.present?
      User.find_by_id(@receiver_id)
    else
      waves.where('user_id <> ?', user_id ).first.try(:user)
    end
  end
  
  # def receiver=(user)
  # end

  def receiver_id
    @receiver_id || self.receiver.try(:id)
  end
      
  def to_s
    "{ :id => #{self.id}, :sender => #{sender.to_s}, :receiver => #{receiver.to_s} :subject => '#{subject}' }"
  end
    
  private
  
  def find_or_create_recipient_wave(posting)
    if posting.present?
      receiver = User.find_by_id(posting.receiver_id)
      if receiver.present? && (receiver != posting.sender)
        receiver.conversation.with(posting.sender, posting.site) || receiver.create_conversation_with(posting.sender, posting.site)
      end
    end
  end
        
end
