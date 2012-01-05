class MessagesMailer < ApplicationMailer

  def new_message_notification(message)
    @message = message
    @site = message.site
    @host = host_for_site(@site)
    subject = "Message from #{@message.sender.handle} at #{@site.display_name}"
    mail :from => @site.mailer, :to => email_for_environment(@message.receiver.email), :subject => subject
  end

end
