class PasswordsMailer < ActionMailer::Base

  default :from => "michael@friskyhands.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #   en.user_session_mailer.forgot_password.subject

  def reset(user)
    @user = user
    email = Rails.env.production? ? @user.email : 'michael@michaelbamford.com'
    mail :to => email, :subject => "Reset FriskyHands Password"
  end

end
