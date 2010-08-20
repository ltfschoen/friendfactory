module BrowserDetectHelper

  def browser_is? name    
    name = name.to_s.strip.downcase
    return true if browser == name
    return true if name == 'mozilla' && browser == 'gecko'
    return true if name == 'ie' && browser.index('ie')
    return true if name == 'webkit' && request.user_agent.downcase.index('webkit')
  end

  def browser
    @browser ||= begin
      ua = request.user_agent.downcase
      if ua.index('msie')
        :msie
      elsif ua.index('gecko/') && ua.index('firefox/')
        :firefox
      elsif ua.index('opera')
        :opera
      elsif ua.index('konqueror') 
        :konqueror
      elsif ua.index('chrome/')
        :chrome
      elsif ua.index('safari/')
        :safari
      elsif ua.index('webkit/')
        :webkit
      elsif ua.index('gecko/')
        :gecko
      elsif ua.index('mozilla/')
        :gecko
      end
    end
  end
  
  def version
    @version ||= begin
      ua = request.user_agent.downcase
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        ua[ ua.index('msie') + 5 ].chr
      end
    end
  end
  
end