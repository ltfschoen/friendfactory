class MessagesMailer < ApplicationMailer

  layout 'mailer'

  helper_method :posting_message

  def new_message_notification(message, host, port)
    set_env(message, host, port)
    subject = "Message from #{message.sender.display_handle} at #{site.display_name}"
    mail :from => site.mailer, :to => email_for_environment(message.receiver.email, message.user.email), :subject => subject do |format|
      format.text
      format.html
    end
  end

  private

  def set_env(message, host, port)
    super(message.receiver, message.site, host, port)
    @posting_message = message
  end

  def posting_message
    @posting_message
  end

end
