class MessagesMailer < ActionMailer::Base

  helper :postings

  default :from => "michael@friskyhands.com"

  def new_message_notification(message)
    if message.present?
      @message = message
      email = Rails.env.development? ? 'michael@michaelbamford.com' : @message.receiver.email    
      mail :to => email, :subject => "Message from #{@message.sender.first_name} at FriskyHands"
    end
  end

end
