class Posting::Message < Posting::Base

  attr_accessible :subject, :body, :receiver_id
  attr_readonly :user_id

  alias_attribute :sender, :user

  attr_writer :receiver_id
  
  has_many :notifications
  
  validates_presence_of :user_id, :receiver_id

  attr_readonly :user_id

  after_create do |posting|
    wave = find_or_create_recipient_wave(posting)
    if wave.present?
      wave.messages << posting
      unless posting.receiver.online?
        MessagesMailer.new_message_notification(posting, wave).try(:deliver)
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
        receiver.conversation.with(posting.sender) || receiver.create_conversation_with(posting.sender)
      end
    end
  end
      
end
