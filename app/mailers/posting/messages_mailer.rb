class Posting::MessagesMailer < ApplicationMailer

  layout 'mailer'

  helper_method :posting

  def create(message, site, host, port)
    @posting, @site, @host, @port = message, site, host, port
    if receiver.emailable?
      mail :from => sender_email, :to => recipient_email, :subject => subject
    end
  end

  private

  def posting
    @posting
  end

  def receiver
    posting.receiver
  end

  ###

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
