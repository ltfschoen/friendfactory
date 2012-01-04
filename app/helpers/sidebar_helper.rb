module SidebarHelper
  def render_ambassadors_list
    if ambassadors = current_site.users.role(:ambassador).includes(:profile)
      render :partial => 'layouts/shared/ambassadors', :object => ambassadors
    end
  end
end