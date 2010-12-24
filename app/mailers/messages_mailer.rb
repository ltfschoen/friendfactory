class MessagesMailer < ActionMailer::Base

  helper :postings

  default :from => "michael@friskyhands.com"

  def new_message_notification(message, conversation)
    if message.present? && conversation.present?
      @message = message
      @conversation = conversation      
      email = Rails.env.development? ? 'michael@michaelbamford.com' : @message.receiver.email    
      mail :to => email, :subject => "Message from #{@message.sender.first_name} at FriskyHands"
    end
  end

end
