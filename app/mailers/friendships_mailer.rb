class FriendshipsMailer < ActionMailer::Base
  
  default :from => "mailer@friskyfactory.com"

  def new_poke_mail(site, poke)
    if poke.present?
      @poke = poke
      @host = ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
      email = Rails.env.production? ? @poke.friend.email : 'michael@michaelbamford.com'
      subject = "#{@poke.profile.handle} at #{site.display_name} wants to meet you!"
      mail :to => email, :subject => subject
    end
  end
  
end
