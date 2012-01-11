module SidebarHelper
  def render_ambassadors_list
    home_wave_user_id = current_site.home_wave[:user_id]
    if ambassadors = current_site.users.persona(:ambassador).where([ '`users`.`id` <> ?', home_wave_user_id ])
      render :partial => 'layouts/shared/ambassadors', :object => ambassadors
    end
  end
end