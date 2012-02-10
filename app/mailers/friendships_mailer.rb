class FriendshipsMailer < ApplicationMailer

  layout 'mailer'

  helper_method :poke

  def new_poke_mail(poke, site, host, port)
    set_env(poke, site, host, port)
    subject = "#{poke.user.display_handle} at #{site.display_name} sent you a cocktail"
    mail :from => site.mailer, :to => email_for_environment(poke.friend.email, poke.user.email), :subject => subject do |format|
      format.text
      format.html
    end
  end

  private

  def set_env(poke, site, host, port)
    super(poke.friend, site, host, port)
    @poke = poke
  end

  def poke
    @poke
  end

end
