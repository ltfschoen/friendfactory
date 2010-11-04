module AvatarHelper
  def avatar_image_tag(user_or_avatar, opts = {})
    opts.reverse_merge!(:online_badge => true)
    if user_or_avatar.present?
      user, avatar = user_or_avatar.is_a?(User) ?
          [ user_or_avatar, user_or_avatar.profile.avatar ] :
          [ user_or_avatar.user, user_or_avatar ]
          
      if user.present? && avatar.present?    
        online = 'online' if (user.online? && (opts[:online_badge] == true))
        klass  = [ 'avatar', opts[:style], online, opts[:class] ].compact * ' '
        link_to(image_tag(avatar.image.url(opts[:style].to_sym), :alt => user.full_name, :class => klass, :site => false), profile_path(user.profile))
      end
    end
  end      
end