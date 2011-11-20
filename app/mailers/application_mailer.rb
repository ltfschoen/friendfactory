class ApplicationMailer < ActionMailer::Base

  default :from => Site::DefaultMailer

  def email_for_environment(email)
    [ 'staging', 'production' ].include?(Rails.env) ? email : 'michael@michaelbamford.com'
  end

  def host_for_site(site)
    ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
  end

end