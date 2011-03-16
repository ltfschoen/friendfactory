class FriskyhandsSite < ApplicationSite  
  def id
    1
  end
  
  def name
    "friskyhands"
  end
  
  def layout
    name
  end
  
  def analytics_account_number
    'UA-19948002-1'
  end
  
  def analytics_domain_name
    '.friskyhands.com'
  end  
end