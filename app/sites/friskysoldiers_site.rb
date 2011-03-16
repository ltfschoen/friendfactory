class FriskysoldiersSite < ApplicationSite
  def id
    3
  end
  
  def name
    "friskysoldiers"
  end
    
  def layout
    name
  end  

  def launch?
    true
  end  
  
  def analytics_account_number
    'UA-19948002-3'
  end
  
  def analytics_domain_name
    '.friskysoldiers.com'
  end
end