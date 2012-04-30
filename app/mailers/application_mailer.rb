class ApplicationMailer < ActionMailer::Base

  default :from => Site::DefaultMailer

  # attr_reader :site, :host, :port

  helper_method \
      :recipient,
      :posting,
      :site,
      :host,
      :port,
      :host_with_port,
      :featured_personages

  DummyEmail  = 'michael@michaelbamford.com'

  def create(recipient, posting, site, host, port)
    @recipient, @posting, @site, @host, @port = recipient, posting, site, host, port
  end

  private

  def email_for_environment(email, current_user_email = nil)
    case Rails.env
    when 'production' || 'test'
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

  def set_env(recipient, site, host, port)
    @recipient, @site, @host, @port = recipient, site, host, port
  end

  def recipient
    @recipient
  end

  def posting
    @posting
  end

  def site
    @site
  end

  def host
    @host
  end

  def port
    @port
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