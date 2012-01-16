module SidebarHelper

  def render_ambassadors_list
    home_user_id = current_site.user_id
    if ambassadors = Personage.enabled.site(current_site).
        type(:ambassador).
        includes(:persona => :avatar).
        where([ '`personages`.`id` <> ?', home_user_id ])
      render :partial => 'layouts/shared/ambassadors', :object => ambassadors
    end
  end

  def personages_select_tag(personage)
    personages = Personage.enabled.where(:user_id => personage[:user_id]).all
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

  def render_sidebar_headshot
    if content_for? :sidebar_headshot
      content_tag(:div, content_for(:sidebar_headshot ), :class => 'block')
    end
  end

end