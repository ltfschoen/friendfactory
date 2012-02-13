# encoding: utf-8

module Wave::ProfilesHelper

  def render_friendships(wave)
    friends = wave.user.friends.site(current_site)
    content_tag(:div, :class => 'attachment') do
      friends.map { |friend| profile_avatar_image_tag(friend, :style => :thumb, :anonymous => true) }.join.html_safe
    end
  end

  def link_to_close(id)
    link_to "×", unpublish_wave_path(id), :title => 'Close', :class => 'close', :remote => true, :method => :put, :'data-type' => :json
  end

  def headshot_tag(profile)
    if profile.present?
      render :partial => 'wave/profiles/headshot', :locals => { :profile => profile }
    end
  end

end
