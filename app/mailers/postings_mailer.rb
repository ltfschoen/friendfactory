class PostingsMailer < ApplicationMailer

  layout 'mailer'

  helper_method :posting

  def new_message_notification(message, host, port)
    set_env(message, message.receiver, message.site, host, port)
    subject = "Message from #{message.sender.display_handle} at #{site.display_name}"
    mail :from => site.mailer, :to => email_for_environment(message.receiver.email, message.user.email), :subject => subject do |format|
      format.text
      format.html
    end
  end

  def new_comment_notification(comment, host, port)
    set_env(comment, nil, nil, host, port)
    mail :from => site.mailer, :to => email_for_environment(comment.receiver.email, comment.user.email), :subject => subject do |format|
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
