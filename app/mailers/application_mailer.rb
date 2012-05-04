class ApplicationMailer < ActionMailer::Base

  default :from => Site::DefaultMailer

  attr_reader :recipient, :posting, :site, :host, :port

  helper_method \
      :recipient,
      :posting,
      :site,
      :host,
      :port,
      :host_with_port,
      :featured_personages

  def create(recipient, posting, site, host, port)
    @recipient, @posting, @site, @host, @port = recipient, posting, site, host, port
  end

  private

  def site_mailer
    defined?(@site) ? @site.mailer : Site::DefaultMailer
  end

  def email_for_environment(email, alternate_email = nil)
    case Rails.env
    when 'production'
      email
    when 'staging'
      Rails.configuration.dummy_email || alternate_email
    when 'test'
      email
    else
      Rails.configuration.dummy_email
    end
  end

  def host_for_site(site)
    ActionMailer::Base.default_url_options[:host].gsub('friskyfactory', site.name)
  end

  def set_env(recipient, site, host, port)
    @recipient, @site, @host, @port = recipient, site, host, port
  end

  def host_with_port
    @host_with_port ||= begin
      if defined?(@host)
        @host + (port != 80 ? ":#{port}" : '')
      end
    end
  end

  def featured_personages(limit = 6)
    if site
      Personage.enabled.site(site).joins(:persona).merge(Persona::Base.featured).limit(limit).order('rand()')
    else
      []
    end
  end

end