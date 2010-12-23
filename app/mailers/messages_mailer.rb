class MessagesMailer < ActionMailer::Base

  helper :postings

  default :from => "michael@friskyhands.com"

  def sent(conversation, message)
    @conversation = conversation
    @message = message
    
    email = case Rails.env
    when 'production' then @conversation.user.email
    when 'staging'    then @conversation.recipient.email # to test on staging
    else 'michael@michaelbamford.com'
    end
    
    mail :to => email, :subject => "Message from #{@conversation.recipient.first_name} at FriskyHands"
  end

end
