class PasswordsMailer < ApplicationMailer

  def reset(user, site)
    @user, @site = user, site
    @host = host_for_site(@site)
    subject = "Reset #{@site.display_name} Password"
    mail :from => @site.mailer, :to => email_for_environment(@user.email), :subject => subject
  end

end
