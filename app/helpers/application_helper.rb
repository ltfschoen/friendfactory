module ApplicationHelper
  
  Site = Struct.new(:name, :header, :footer)
  
  def current_site
    @current_site ||= Site.new(
        ApplicationController::SiteName,
        render(:partial => 'layouts/header'),
        render(:partial => 'layouts/footer'))
  end
  
end