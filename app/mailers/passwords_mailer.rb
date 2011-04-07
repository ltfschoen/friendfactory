class PasswordsMailer < ActionMailer::Base

  default :from => "michael@friskyhands.com"

  def reset(user, current_site)
    @user, @current_site = user, current_site
    email = Rails.env.production? ? @user.email : 'michael@michaelbamford.com'
    mail :to => email, :subject => "Reset FriskyHands Password"
  end

end
