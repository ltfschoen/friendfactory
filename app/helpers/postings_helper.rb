module PostingsHelper
  
  def render_attachment(object)
    render(:partial => 'posting/post_its/attachment', :locals => { :post_it => object })
  end
  
  def render_postings(collection, opts={})
    if opts[:only].present?
      collection = collection.select{ |posting| posting[:type] == opts[:only].to_s }
    end
    
    if opts[:exclude].present?
      collection = collection.reject{ |posting| posting[:type] == opts[:exclude].to_s }
    end
    
    render :partial => 'posting/posting', :collection => collection
  end

  def avatar_image_tag(user_or_avatar, opts = {})
    if user_or_avatar.is_a?(Hash)
      opts = user_or_avatar
      user_or_avatar = nil
    end
    
    opts.reverse_merge!(
        :online_badge    => true,
        :style           => :polaroid,
        :site            => false,
        :anonymous       => true,
        :link_to_profile => true)    
    
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
        
        image_tag = image_tag(avatar.image.url(opts[:style].to_sym),
            :alt   => opts[:alt],
            :class => klass,
            :site  => opts[:site],
            :id    => opts[:id])
        
        if opts[:link_to_profile]
          return link_to(image_tag, wave_profile_path(user.profile), :class => 'profile')
        else
          return image_tag
        end
      end
    end

    # user_or_avatar not present
    
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
