class Posting::MessagesMailer < ApplicationMailer

  layout 'mailer'

  def create(recipient, message, site, host, port)
    super
    mail :from => sender_email, :to => recipient_email, :subject => subject
  end

  private

  def sender_email
    site.mailer
  end

  def recipient_email
    email_for_environment(posting.receiver.email, posting.sender.email)
  end

  def subject
    @subject ||= begin
      "Message from #{posting.sender.display_handle} at #{site.display_name}"
    end
  end

end
