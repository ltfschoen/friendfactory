class MessagesMailer < ApplicationMailer

  def new_message_notification(message)
    @message, @site = message, message.site
    @host = host_for_site(@site)
    subject = "Message from #{@message.sender.handle(@message.site)} at #{@site.display_name}"
    mail :from => @site.mailer, :to => email_for_environment(@message.receiver.email), :subject => subject
  end

end
