module AvatarHelper
  def avatar_image_tag(user_or_avatar, opts = {})    
    opts.reverse_merge!(:online_badge => true, :style => :polaroid, :site => false)
    klass = [ 'avatar', opts[:style], opts[:class] ].compact * ' '
    
    if user_or_avatar.present?
      user, avatar = user_or_avatar.is_a?(User) ?
          [ user_or_avatar, user_or_avatar.profile.avatar ] :
          [ user_or_avatar.user, user_or_avatar ]

      if user.present? && avatar.present?
        opts.reverse_merge!(:alt => user.first_name)
        online = 'online' if (user.online? && (opts[:online_badge] == true))
        klass  = [ klass, online ].compact * ' '
        return link_to(image_tag(avatar.image.url(opts[:style].to_sym), :alt => opts[:alt], :class => klass, :site => opts[:site]), profile_path(user.profile))
      end
    end
    image_tag('ffffff.gif', :class => klass, :site => false)
  end  
end
