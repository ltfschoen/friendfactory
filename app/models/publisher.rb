class Publisher
  
  def initialize(publish_to)
    @publish_to = publish_to
  end
  
  def after_create(posting)
    wave = case
      when @publish_to[:slug].present? then Wave::Base.find_by_slug(@publish_to[:slug])
      when @publish_to[:wave] == Wave::Profile then Wave::Profile.find_by_user_id(posting.user_id)
      when @publish_to[:wave] == Wave::Conversation then find_or_create_conversation_wave(posting)
    end
    wave.postings << posting if wave.present?
  end
  
  private
  
  def find_or_create_conversation_wave(posting)
    if posting.present?
      receiver = User.find_by_id(posting.receiver_id)
      if receiver.present? && (receiver != posting.sender)
        receiver.conversation.with(posting.sender) || receiver.create_conversation_with(posting.sender)
      end
    end
  end
  
end