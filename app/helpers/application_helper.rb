module ApplicationHelper
  
  Site = Struct.new(:name, :header)
  
  def current_site
    Site.new(ApplicationController::SiteName, render(:partial => 'layouts/header'))
  end
  
end
