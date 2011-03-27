class MessagesMailer < ActionMailer::Base

  helper :postings

  default :from => "michael@friskyhands.com"

  def new_message_notification(message)
    @message = message
    email = Rails.env.development? ? 'michael@michaelbamford.com' : @message.receiver.email    
    #TODO Add 'at FriskyHands' to subject
    mail :to => email, :subject => "Message from #{@message.sender.handle(@message.site)}"
  end

end
