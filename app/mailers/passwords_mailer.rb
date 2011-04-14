class PasswordsMailer < ActionMailer::Base

  def reset(user, current_site)
    @user, @current_site = user, current_site
    email = Rails.env.production? ? @user.email : 'michael@michaelbamford.com'
    mail :to     => email,
        :from    => "mailer@#{current_site.name}.com",
        :subject => "Reset #{current_site.display_name} Password"
  end

end
