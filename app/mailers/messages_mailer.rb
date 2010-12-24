class MessagesMailer < ActionMailer::Base

  helper :postings

  default :from => "michael@friskyhands.com"

  def sent(conversation, message)
    @conversation = conversation
    @message = message    
    
    if Rails.env.development?      
      email = 'michael@michaelbamford.com'
    end
    
    mail :to => email, :subject => "Message from #{@conversation.recipient.first_name} at FriskyHands"
  end

end
