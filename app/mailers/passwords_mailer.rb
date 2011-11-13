class PasswordsMailer < ApplicationMailer

  def reset(user, current_site)
    @user, @current_site = user, current_site
    @host = host_for_site(@current_site)
    subject = "Reset #{current_site.display_name} Password"
    mail :from => @site.mailer, :to => email_for_environment(@user.email), :subject => subject
  end

end
