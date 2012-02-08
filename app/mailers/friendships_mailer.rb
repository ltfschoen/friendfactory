class FriendshipsMailer < ApplicationMailer

  class << self
    def new(*args)
      super
    end
  end

  def set_controller(controller)
    @controller = controller
  end

  def new_poke_mail(poke, site, host, port)
    if poke.friend.emailable?
      @poke = poke
      @site = site
      @host = host
      @host_with_port = host_with_port(host, port)
      @featured_personages = featured_personages(site)
      subject = "#{@poke.user.handle} at #{@site.display_name} has sent you a cocktail!"
      mail :from => @site.mailer, :to => email_for_environment(@poke.friend.email), :subject => subject do |format|
        format.html { render :layout => false }
        format.text
      end
    end
  end

  private

  def host_with_port(host, port)
    host += ":#{port}" if port != 80
    host
  end

  def featured_personages(site)
    Personage.enabled.site(site).joins(:user).merge(User.featured).limit(6).order('rand()')
  end

end
