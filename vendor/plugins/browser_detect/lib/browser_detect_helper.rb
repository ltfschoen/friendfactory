
module BrowserDetectHelper

  # useful method to render parts of the site only when a certain browser is detected.
  # e.g. <% if browser_is('mozilla') %> blah. <% end %>
  
  def browser_is name
    name = name.to_s.strip
    return true if browser_name == name
    return true if name == 'mozilla' && browser_name == 'gecko'
    return true if name == 'ie' && browser_name.index('ie')
    return true if name == 'webkit' && ['safari','mobile safari'].includes?(browser_name)
  end

  # returns the browser name in a readable form.
  
  def browser_name
    @browser_name ||= begin

      ua = request.env['HTTP_USER_AGENT'].downcase
      
      if ua.index('webtv')
        'webtv'
      elsif ua.index(/(Mobile\/.+Safari)/)
        'mobile safari'
      elsif ua.index('gecko/')
        'gecko'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror') 
        'konqueror'
      elsif ua.index('chrome/') # chrome
        #Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/532.5 (KHTML, like Gecko) Chrome/4.0.249.78 Safari/532.5
        'chrome'
      elsif ua.index('applewebkit/')
        #Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10
        'safari'
      elsif ua.index('msie')
        'ie'+ua[ua.index('msie')+5].chr
      elsif ua.index('mozilla/')
        'gecko'
      elsif ua.index('Rails')
        'rails'
      elsif ua.index('nagios')
        'nagios'
        #check_http/v2053 (nagios-plugins 1.4.13)
      else
        ''
      end
    
    end
  end
  
  # returns the user operating system
  # only Windows, Linux, Macintosh or unknown
  
  def user_os_simple
    @user_os_simple ||= begin
      ua = request.env['HTTP_USER_AGENT'].downcase
      if ua.index('win')
        "Windows"
      elsif ua.index('linux')
        "Linux"
      elsif ua.index('macintosh')
        "Macintosh"
      elsif ua.index('ipod') # iPod Touch
        "iPod"
      elsif ua.index('iphone')
        "iPhone"
      elsif ua.index('ipad')
        "iPad"
      else
        "unknown"
      end
    end
  end
  
  # tries to be more specific with the user os.
  # supporting: WinXP,W2000,Win7,Vista,W2003,Linux,Mac,Win98,WinNT,Win95
  # TODO: still have to do this. maybe get some clue from here: http://priyadi.net/wp-content/plugins/browsniff.txt
  
  #def user_os_complex
  #end
  
  def browser_version
    if browser_is('ie')
      return request.env['HTTP_USER_AGENT'].match(/^.*?MSIE ([0-9]{1}.[0-9]){1}.*?/)[1].to_f
    end
    if browser_is('mozilla')
      return request.env['HTTP_USER_AGENT'].match(/^.*?Firefox\/([0-9]{1}.[0-9]){1}.*?/)[1].to_f
    end
    if browser_is('webkit')
      return request.env['HTTP_USER_AGENT'].match(/^.*?Safari\/([\d]+\.[\d]+[\.\d]*)?/)[1].to_f
    end
  end

end
