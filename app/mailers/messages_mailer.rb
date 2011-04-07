class MessagesMailer < ActionMailer::Base

  default :from => "michael@friskyhands.com"

  def new_message_notification(message)
    @message = message
    email = Rails.env.production? ? @message.receiver.email : 'michael@michaelbamford.com'
    #TODO Add 'at FriskyHands' to subject
    mail :to => email, :subject => "Message from #{@message.sender.handle(@message.site)}"
  end

end
