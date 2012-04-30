class Posting::CommentsMailer < ApplicationMailer

  layout 'mailer'

  def create(recipient, comment, site, host, port)
    super
    mail :from => site_mailer, :to => recipient_email, :subject => subject
  end

  private

  def recipient_email
    email_for_environment(recipient.email, posting.user.email)
  end

  def subject
    "Comment from #{posting.user.display_handle} at #{site.display_name}"
  end

end
