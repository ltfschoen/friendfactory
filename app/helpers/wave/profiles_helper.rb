module Wave::ProfilesHelper

  def render_profile_wave_posting(posting)
    posting.class == Posting::Avatar ? render(:partial => 'avatar', :object => posting) : render_posting(posting)
  end
  
  def buddy_link_class(profile_id)
    css = ['buddy', 'icon'] << (current_user.friend_ids.include?(profile_id) ? 'buddied' : nil)
    css.compact.join(' ')
  end

  def poke_link_class(profile_id, additional_css_class = nil)
    css = [ 'pokes', 'icon', additional_css_class ]
    css << ((current_profile.id != profile_id) && current_profile.has_poked?(profile_id) ? 'poked' : nil)
    css.compact.join(' ')
  end

  def link_to_send_cocktail(profile)
    if current_profile.present? && (current_profile.id != profile.id)
      msg = "Send #{profile.handle} a Cocktail"
      if current_profile.has_poked?(profile.id)
        msg = "Don't " + msg
        disable_with = "Trashing cocktail..."
      else
        disable_with = "Sending cocktail..."
      end
      link_to(msg, poke_new_friendship_path(:profile_id => profile.id),
          :class => 'poke',
          :remote => true,
          :method => :post,
          :'data-type' => :json,
          :'data-disable-with' => disable_with)
    end
  end

  def render_friendships(wave)
    friends = wave.user.friends.site(current_site)
    content_tag(:div, :class => 'attachment') do
      friends.map { |friend| profile_avatar_image_tag(friend, :style => :thumb, :anonymous => true) }.join.html_safe
    end
  end

end
