module Admin::InvitationsHelper  

  def link_to_column_name_with_sort_direction_arrow(site, display_name, sort_column)
    html = link_to(display_name, admin_site_invitation_sites_with_sort_path(site, sort_column))
    html << sort_direction_arrow(sort_column)
    html
  end

  def admin_site_invitation_sites_with_sort_path(site, sort_column)
    sort_direction = params[:sort] == sort_column ? (params[:direction] == 'asc' ? 'desc' : 'asc') : 'asc'
    admin_site_invitation_sites_path(site, :sort => sort_column, :direction => sort_direction)
  end

  def sort_direction_arrow(sort_column)
    if params[:sort] == sort_column
      ('&nbsp;' << (params[:direction] == 'asc' ? "&uarr;" : "&darr;")).html_safe
    end
  end

end
