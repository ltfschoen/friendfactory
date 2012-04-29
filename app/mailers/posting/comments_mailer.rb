class Posting::CommentsMailer < ApplicationMailer

  layout 'mailer'

  helper_method :posting

  def new_message_notification(message, site, host, port)
    recipient = message.receiver
    set_env(message, recipient, site, host, port)
    subject = "Message from #{message.sender.display_handle} at #{site.display_name}"
    mail :from => site.mailer, :to => email_for_environment(recipient.email, message.user.email), :subject => subject do |format|
      format.text
      format.html
    end
  end

  def new_comment_notification(comment, recipient, site, host, port)
    set_env(comment, recipient, site, host, port)
    subject = "Comment from #{comment.user.display_handle} at #{site.display_name}"
    mail :from => site.mailer, :to => email_for_environment(recipient.email, comment.user.email), :subject => subject do |format|
      format.text
      format.html
    end
  end

  private

  def set_env(posting, recipient, site, host, port)
    super(recipient, site, host, port)
    @posting = posting
  end

  def posting
    @posting
  end

end
