class ApplicationMailer < ActionMailer::Base

  default :from => Site::DefaultMailer

  DummyEmail  = 'michael@michaelbamford.com'

  private

  def email_for_environment(email, current_user_email = nil)
    case Rails.env
    when 'production'
      email
    when 'staging'
      current_user_email || DummyEmail
    else
      DummyEmail
    end
  end

  def host_for_site(site)
    ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
  end

end