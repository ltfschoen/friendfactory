class ApplicationMailer < ActionMailer::Base

  default :from => Site::DefaultMailer

  private

  def email_for_environment(email)
    [ 'production' ].include?(Rails.env) ? email : 'michael@michaelbamford.com'
  end

  def host_for_site(site)
    ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
  end

end