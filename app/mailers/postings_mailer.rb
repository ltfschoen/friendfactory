class PostingsMailer < ApplicationMailer

  layout 'mailer'

  helper_method :posting

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
