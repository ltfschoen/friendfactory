module ApplicationHelper  
  
  def presenter
    @presenter ||= Presenter.new    
  end
  
end