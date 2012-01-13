module SidebarHelper

  def render_ambassadors_list
    home_wave_user_id = current_site.home_wave[:user_id]
    if ambassadors = Personage.site(current_site).
        type(:ambassador).
        includes(:persona => :avatar).
        where([ '`personages`.`id` <> ?', home_wave_user_id ])
      render :partial => 'layouts/shared/ambassadors', :object => ambassadors
    end
  end

  def personages_select_tag(personage)
    personages = Personage.where(:user_id => personage[:user_id]).all
    if personages.length == 1
      link_to current_user.handle, url_for(current_profile)
    else
      select_tag 'id', options_from_collection_for_select(personages, :id, :description, current_user.id),
          :include_blank => false,
          :'data-remote' => true,
          :'data-method' => :put,
          :'data-url'    => switch_personages_path(:format => :js)
    end
  end

  def render_sidebar_headshot
    if content_for? :sidebar_headshot
      content_tag(:div, content_for(:sidebar_headshot ), :class => 'block')
    end
  end

end