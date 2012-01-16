module SidebarHelper

  def render_sidebar_ambassador
    content_tag(:div, :class => 'block ambassador') do
      content_tag(:div, thimble_image_tag(current_site.home_user), :class => 'portrait') <<
        link_to(current_site.home_wave.subject, root_path)
    end
  end

  def render_sidebar_users_list(user_type)
    home_user_id = current_site[:user_id]
    if users = Personage.enabled.site(current_site).type(user_type).includes(:persona => :avatar).exclude(home_user_id)
      render :partial => 'layouts/shared/users_list', :locals => { :users => users, :user_type => user_type }
    end
  end

  def render_sidebar_ambassadors_list
    render_sidebar_users_list(:ambassador)
  end

  def render_sidebar_places_list
    render_sidebar_users_list(:place)
  end

  def render_sidebar_headshot
    if content_for? :sidebar_headshot
      content_tag(:div, content_for(:sidebar_headshot ), :class => 'block')
    end
  end

  def personages_select_tag(personage)
    personages = Personage.enabled.where(:user_id => personage[:user_id]).all.sort_by { |p| p.display_name }
    case
    when personages.length == 1
      link_to current_user.handle, url_for(current_profile)
    when personages.length > 1
      select_tag 'personage[id]', options_from_collection_for_select(personages, :id, :display_name, current_user.id),
          :include_blank => false,
          :'data-remote' => true,
          :'data-method' => :put
    end
  end

end