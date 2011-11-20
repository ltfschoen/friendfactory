class MessagesMailer < ApplicationMailer

  BamfordId = 1
  LyonId = 2

  def new_message_notification(message)
    @message, @site = message, message.site
    @host = host_for_site(@site)
    subject = "Message from #{@message.sender.handle(@message.site)} at #{@site.display_name}"
    mail :from => @site.mailer, :to => email_for_environment(@message.receiver.email), :bcc => bcc_for_environment(message), :subject => subject
  end

  private

  def bcc_for_environment(message)
    if [ 'staging', 'production' ].include?(Rails.env) && [ BamfordId, LyonId ].include?(message.sender_id)
      message.sender.email
    end
  end

end
