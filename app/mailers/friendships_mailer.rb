class FriendshipsMailer < ActionMailer::Base
  
  def new_poke_mail(site, poke)
    return unless site.present? && poke.present?
    @site = site
    @poke = poke
    original_host = ActionMailer::Base.default_url_options[:host]
    ActionMailer::Base.default_url_options[:host].gsub!('friskyfactory', @site.name)
    @host = ActionMailer::Base.default_url_options[:host]
    @subject = "#{@poke.profile.handle} at #{@site.display_name} has sent you a cocktail!"
    @wave_profile_url = wave_profile_url(@poke.sender)
    @unsubscribe_href = "mailto:unsubscribe@friskyfactory.com?subject=Unsubscribe from #{@site.name} cocktails&body=To #{@site.name},%0A%0APlease don't email me any more cocktails. Thanks!%0A%0AFrom #{@poke.receiver.handle}"
    ActionMailer::Base.default_url_options[:host] = original_host

    mail(:from => @site.mailer, :to => email_for_environment(@poke.friend), :cc => cc_for_environment(@poke.profile), :subject => @subject) do |format|
      format.html { render :layout => false }
      format.text
    end
  end

  private

  def email_for_environment(receiver_profile)
    case Rails.env
    when 'production' then receiver_profile.email
    when 'staging' && receiver_profile.admin? then receiver_profile.email
    else 'michael@michaelbamford.com'
    end
  end

  def cc_for_environment(sender_profile)
    Rails.env.staging? ? sender_profile.email : nil
  end
  
end
