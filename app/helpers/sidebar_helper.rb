module SidebarHelper

  SidebarUserListMaximumLength = 3
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
    home_user = current_site.home_user
    url = url_for(home_user.profile)
    unless current_page?(url) && content_for?(:sidebar_headshot)
      render :partial => 'layouts/shared/sidebar/home_user', :object => home_user, :locals => { :url => url }
    end
  end

  ###

  def content_for_sidebar_users_list(personages, persona_type, rollcall_path)
    personages_length = personages.length
    case
    when personages_length > SidebarUserListMaximumLength
      personages = personages[0..(sidebar_rollcall_length(personages_length)-1)]
      render :partial => 'layouts/shared/sidebar/rollcall', :locals => { :users => personages, :persona_type => persona_type, :rollcall_path => rollcall_path }
    when personages_length > 0
      render :partial => 'layouts/shared/sidebar/personages', :object => personages, :locals => { :persona_type => persona_type, :rollcall_path => rollcall_path }
    end
  end

  def content_for_sidebar_rollcall(personages, rollcall_path)
    content_for :sidebar_rollcall do
      content_for_sidebar_users_list(personages, 'person', rollcall_path)
    end
  end

  def render_sidebar_rollcall
    if content_for? :sidebar_rollcall
      content_for(:sidebar_rollcall)
    end
  end

  def render_sidebar_users_list(persona_type)
    home_user_id = current_site[:user_id]
    personages = Personage.sidebar_rollcall(current_site, persona_type, SidebarRollCallMaximumLength, home_user_id)
    rollcall_path = persona_type_profiles_path(:persona_type => persona_type.to_s.pluralize)
    content_for_sidebar_users_list(personages, persona_type, rollcall_path)
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

  def render_sidebar_online_rollcall
    personages = Personage.joins(:user).merge(User.online)
    content_for_sidebar_users_list(personages, 'online', online_profiles_path)
  end

  ###

  def content_for_sidebar_headshot(user)
    content_for :sidebar_headshot, render_headshot(user)
  end

  def render_sidebar_headshot
    if content_for? :sidebar_headshot
      content_tag(:div, content_for(:sidebar_headshot ), :class => 'block')
    end
  end

  ###

  def render_sidebar_search
    if false
      text_field_tag 'search', :placeholder => "Search"
    end
  end

  def render_sidebar_tag_cloud
    if content_for? :sidebar_tag_cloud
      content_tag(:div, content_for(:sidebar_tag_cloud), :class => 'block tag_cloud')
    end
  end

  def content_for_sidebar_tag_cloud(tags, current_tag, proc_path)
    tag_cloud(tags, %w(tag1 tag2 tag3 tag4)) do |tag, css_class|
      tag_as_param = tag.name.gsub(/\s/, '-').downcase
      current = false

      if tag_as_param == current_tag
        current = true
        css_class += " current"
        tag_as_param = nil
      end

      content_for :sidebar_tag_cloud do
        link_to(tag.name, proc_path.call(tag_as_param), :class => css_class)
      end

      content_for :sidebar_tag_cloud do
        link_to("(untag)", proc_path.call(nil), :class => 'tag1 current')
      end if current
    end
  end

  def personages_select_tag(personage)
    if current_user.admin?
      select_tag 'personage[id]', grouped_options_for_select(personages_group_by_current_state(personage), current_user.id),
          :'data-remote' => true,
          :'data-method' => :put
    else
      link_to_profile(current_user)
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

  def current_page_for_wave?(profile)
    current_page?(url_for(profile))
  end

  private

  def sidebar_rollcall_length(current_length)
    [ current_length / 5 * 5, SidebarRollCallMaximumLength ].min
  end

  def personages_group_by_current_state(personage)
    Personage.site(current_site).
        where(:user_id => personage[:user_id]).
        includes(:persona).
        sort_by { |p| p.display_name }.
        group_by(&:current_state).
        sort { |a, b| b.first <=> a.first }.
        map { |state, personages| [ state.to_s.titleize, personages.map { |personage| [ personage.display_name, personage.id ] }]}
  end

end