module AvatarHelper
  
  def avatar_image_tag(user_or_avatar, opts = {})
    if user_or_avatar.is_a?(Hash)
      opts = user_or_avatar
      user_or_avatar = nil
    end
    
    opts.reverse_merge!(:online_badge => true, :style => :polaroid, :site => false, :anonymous => true)    
    if opts[:style].to_sym == :thimble
      opts[:style], opts[:class] = :thumb, 'thimble'
    end

    klass = [ 'avatar', opts[:style], opts[:class] ]
        
    if user_or_avatar.present?
      user, avatar = user_or_avatar.is_a?(User) ?
          [ user_or_avatar, user_or_avatar.profile.avatar ] :
          [ user_or_avatar.user, user_or_avatar ]

      if user.present? && avatar.present?
        opts.reverse_merge!(:alt => user.first_name)
        online = 'online' if (user.online? && (opts[:online_badge] == true))
        klass = (klass << online).compact * ' '
        # TODO return link_to(..., profile_path(user.profile))
        return image_tag(avatar.image.url(opts[:style].to_sym), :alt => opts[:alt], :class => klass, :site => opts[:site], :id => opts[:id])
      end
    end

    if opts[:anonymous] == true
      klass = (klass << 'silhouette').compact * ' '
      with_options :class => klass, :site => false, :id => opts[:id] do |options|
        case opts[:gender]
          when UserInfo::GuyGender
            then options.image_tag 'silhouette-guy.gif'
          when UserInfo::GirlGender
            then options.image_tag 'silhouette-girl.gif'
          else
            options.image_tag 'silhouette-q.gif'
        end
      end      
    end
  end
  
end
