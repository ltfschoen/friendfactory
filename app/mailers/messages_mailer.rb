class MessagesMailer < ActionMailer::Base

  def new_message_notification(message)
    @message = message
    email = Rails.env.production? ? @message.receiver.email : 'michael@michaelbamford.com'
    mail :to   => email,
      :from    => "mailer@#{message.site.name}.com",
      :subject => "Message from #{@message.sender.handle(@message.site)} at #{@message.site.display_name}"
  end

end
