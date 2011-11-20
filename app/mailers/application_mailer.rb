class ApplicationMailer < ActionMailer::Base

  default :from => Site::DefaultMailer

  BamfordId = 1
  LyonId = 2

  private

  def email_for_environment(email)
    [ 'staging', 'production' ].include?(Rails.env) ? email : 'michael@michaelbamford.com'
  end

  def host_for_site(site)
    ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
  end

  def bcc_for_environment(message)
    if [ 'staging', 'production' ].include?(Rails.env) && [ BamfordId, LyonId ].include?(message.sender_id)
      message.sender.email
    end
  end

end