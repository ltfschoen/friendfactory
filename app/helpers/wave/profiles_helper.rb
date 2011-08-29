module Wave::ProfilesHelper

  def render_profile_wave_posting(posting)
    posting.class == Posting::Avatar ? render(:partial => 'avatar', :object => posting) : render_posting(posting)
  end
  
  def buddy_link_class(profile_id)
    css = ['buddy', 'icon'] << (current_user.friend_ids.include?(profile_id) ? 'buddied' : nil)
    css.compact.join(' ')
  end

  def render_friendships(wave)
    friends = wave.user.friends.site(current_site)
    content_tag(:div, :class => 'attachment') do
      friends.map { |friend| profile_avatar_image_tag(friend, :style => :thumb, :anonymous => true) }.join.html_safe
    end
  end

end
