class FriendshipsMailer < ApplicationMailer

  layout 'mailer'

  helper_method :poke

  def create(recipient, poke, site, host, port)
    super
    mail :from => site_mailer, :to => recipient_email, :subject => subject
  end

  private

  alias_method :poke, :posting

  def recipient_email
    email_for_environment(recipient.email)
  end

  def subject
    "#{poke.user.display_handle} at #{site.display_name} sent you a cocktail"
  end

end
