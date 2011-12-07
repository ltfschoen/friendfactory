module CompatibilityHelper

  Browser = Struct.new(:name, :display_name, :version)

  CompatibleBrowsers = [
    Browser.new(:safari, 'Safari', 5.0),
    Browser.new(:firefox, 'Firefox', 4.0),
    Browser.new(:ie, 'Internet Explorer', 9.0),
    Browser.new(:chrome, 'Chrome', 15.0)
  ]

  def compatibility_tag
    noscript_compatibility_tag + browser_compatibility_tag
  end

  private

  def noscript_compatibility_tag
    render :partial => 'layouts/shared/noscript'
  end

  def browser_compatibility_tag
    user_agent = UserAgent.new(request.user_agent)
    browser = CompatibleBrowsers.detect { |browser| browser.name == user_agent.name }
    if browser && (browser.version > user_agent.version.to_f)
      # TODO user_agent.version.to_f may not resolve correctly
      # to a useful number. E.g. "5.1.2" will resolve to 5.1.
      render :partial => 'layouts/shared/nobrowser', :locals => { :browser => browser, :user_agent => user_agent }
    end
  end

end