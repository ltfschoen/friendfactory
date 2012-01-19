module SidebarHelper

  SidebarUserListMaximumLength = 4
  SidebarRollCallMaximumLength = 10

  def render_sidebar_adspace
    if false
      content_tag(:div, image_tag("http://placehold.it/180x75"), :class => 'block adspace')
    end
  end

  def render_sidebar_userspace
    if current_user
      render :partial => 'layouts/shared/sidebar/userspace'
    end
  end

  def render_sidebar_navspace
    render :partial => 'layouts/shared/sidebar/navspace'
  end

  def render_sidebar_home_user
    content_tag(:div, :class => 'block home_user') do
      content_tag(:div, thimble_image_tag(current_site.home_user), :class => 'portrait') <<
      link_to(current_site.home_wave.subject, root_path)
    end
  end

  def render_sidebar_users_list(persona_type, list_maximum_length = SidebarUserListMaximumLength)
    home_user_id = current_site[:user_id]
    personages = Personage.enabled.
        site(current_site).
        type(persona_type).
        joins(:profile).
        includes(:persona => :avatar).
        includes(:profile).
        exclude(home_user_id).
        limit(SidebarRollCallMaximumLength).
        order('`waves`.`updated_at` DESC')

    personages_length = personages.length
    if personages_length > list_maximum_length
      rollcall_length = sidebar_rollcall_length(personages_length)
      personages = personages[0..(rollcall_length-1)]
      render :partial => 'layouts/shared/sidebar/rollcall', :locals => { :users => personages, :persona_type => persona_type }
    else
      render :partial => 'layouts/shared/sidebar/personages', :object => personages, :locals => { :persona_type => persona_type }
    end
  end

  def render_sidebar_ambassadors_list
    render_sidebar_users_list(:ambassador)
  end

  def render_sidebar_places_list
    render_sidebar_users_list(:place)
  end

  def render_sidebar_communities_list
    render_sidebar_users_list(:community)
  end

  def render_sidebar_headshot
    if content_for? :sidebar_headshot
      content_tag(:div, content_for(:sidebar_headshot ), :class => 'block')
    end
  end

  def render_sidebar_rollcall
    if content_for? :sidebar_rollcall
      content_for(:sidebar_rollcall)
    end
  end

  def render_sidebar_search
    if false
      text_field_tag 'search', :placeholder => "Search"
    end
  end

  def render_sidebar_tag_cloud
    if content_for? :tag_cloud
      content_tag(:div, content_for(:tag_cloud), :class => 'block tag_cloud')
    end
  end

  ###

  def sidebar_rollcall(users)
    max = sidebar_rollcall_length(users.length)
    content_for :sidebar_rollcall do
      render :partial => 'layouts/shared/sidebar/rollcall', :locals => { :users => users[0..(max-1)], :persona_type => 'person' }
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

  def link_to_unread_messages_unless_inbox
    unless [ inbox_path, wave_conversations_path ].detect{ |path| current_page?(path) }.present?
      link_to_unread_messages
    end
  end

  def link_to_unread_messages
    if current_user
      unread_conversations_count = current_user.inbox(current_site).unread.count
      if unread_conversations_count > 0
        link_to(unread_conversations_count, inbox_path, :class => 'unread')
      end
    end
  end

  private

  def sidebar_rollcall_length(current_length, default_max = 10)
    [ current_length / 5 * 5, default_max ].min
  end

end