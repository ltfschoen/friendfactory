class FriendshipsMailer < ApplicationMailer

  def new_poke_mail(poke, site)
    @site, @poke = site, poke
    @wave_profile_url = wave_profile_url(@poke.sender, :host => host_for_site(@site))
    @unsubscribe_href = "mailto:unsubscribe@friskyfactory.com?subject=Unsubscribe from #{@site.name} cocktails&body=To #{@site.name},%0A%0APlease don't email me any more cocktails. Thanks!%0A%0AFrom #{@poke.receiver.handle}"
    subject = "#{@poke.profile.handle} at #{@site.display_name} has sent you a cocktail!"

    mail(:from => @site.mailer, :to => email_for_environment(@poke.friend.email), :subject => subject) do |format|
      format.html { render :layout => false }
      format.text
    end
  end

end
