class FriendshipsMailer < ActionMailer::Base
  
  default :from => "mailer@friskyfactory.com"

  def new_poke_mail(site, poke)
    if poke.present?
      @poke = poke
      @host = ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
      @subject = "#{@poke.profile.handle} at #{site.display_name} has sent you a cocktail!"
      mail(:to => email_for_environment(@poke.friend), :cc => cc_for_environment(@poke.profile), :subject => @subject) do |format|
        format.html { render :layout => false }
        format.text
      end
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
