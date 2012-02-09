class FriendshipsMailer < ApplicationMailer

  layout 'mailer'

  helper_method \
      :poke,
      :site,
      :host,
      :host_with_port,
      :featured_personages

  def new_poke_mail(poke, site, host, port)
    if poke.friend.emailable?
      set_env(poke, site, host, port)
      subject = "#{poke.user.handle.titleize} at #{site.display_name} sent you a cocktail"
      mail :from => site.mailer, :to => email_for_environment(poke.friend.email, poke.user.email), :subject => subject do |format|
        format.text { render :layout => false }
        format.html
      end
    end
  end

  private

  def set_env(poke, site, host, port)
    @poke, @site, @host, @port = poke, site, host, port
  end

  def poke
    @poke
  end

  def site
    @site
  end

  def host
    @host
  end

  def port
    @port
  end

  def host_with_port
    @host_with_port ||= begin
      current_host = host
      current_host += ":#{port}" if port != 80
      current_host
    end
  end

  def featured_personages
    Personage.enabled.site(site).joins(:user).merge(User.featured).limit(6).order('rand()')
  end

end
