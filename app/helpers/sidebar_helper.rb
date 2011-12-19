module SidebarHelper
  def render_ambassadors_list
    ambassadors = current_site.users.role(:ambassador).includes(:profile)
    if ambassadors.present?
      render :partial => 'layouts/shared/ambassadors', :object => ambassadors
    end
  end
end