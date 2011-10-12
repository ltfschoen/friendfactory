module ApplicationHelper
  
  def form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    super(record_or_name_or_array, *(args << options.merge(:builder => ButtonFormBuilder)), &proc)    
  end

  def remote_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    super(record_or_name_or_array, *(args << options.merge(:builder => ButtonFormBuilder)), &proc)    
  end
  
  def javascript(*files)
    content_for(:javascripts) { javascript_include_tag(*files) }
  end
  
  def stylesheet(*files)
    options = files.extract_options!
    options.reverse_merge!(:site => false)
    site_name = (options[:site] == false) ? 'friskyfactory' : current_site.name
    files.map! { |file| File.join(site_name, *file) }
    content_for(:stylesheets) { stylesheet_link_tag(files) }
  end
    
  def image_tag(source, opts = {})    
    if (opts.delete(:site) == true) && (asset = current_site.assets.type(Asset::Image).find_by_name(File.basename(source, '.*')))
      source = asset.url(:original)
    end
    super(source, opts)
  end
  
  def button_tag(text = nil, opts = {})
    content_tag(:button, text, opts)
  end
  
  def button_tag_if(boolean, text = nil, opts = {})
    button_tag(text, opts) if boolean
  end
  
  def spinner(opts = {})    
    size = case opts[:size]
      when :small then '14x14'
      when :big   then '32x32'
      else '14x14'
    end    
    css_class = [ 'spinner', 'hidden', opts[:class] ].compact * ' '
    image_tag('friskyfactory/ajax-loader.gif', :size => size, :class => css_class, :id => opts[:id], :site => false)
  end
  
  def link_to_profile(profile, opts = {})
    profile = profile.profile(current_site) if profile.is_a?(User)
    if profile.present?
      name = opts[:label] || profile.handle
      link_to(name, wave_profile_path(profile), :class => 'profile username')
    end
  end

  def link_to_bio(opts = {})
    label = opts[:label] || 'Bio'
    # TODO link_to(name, profile_path(user.profile), :class => 'profile') if user.profile
    content_tag(:span, label, :class => 'bio')
  end

  def link_to_facebook
    link_to('', 'http://www.facebook.com/pages/Frisky-Hands/297300376633', :target => 'blank', :class => 'web_logos facebook', :target => '_blank')
  end
  
  def link_to_facebook_shop
    link_to('Shop', 'http://www.facebook.com/pages/Frisky-Hands/297300376633?v=app_135607783795&ref=ts', :target => '_blank')
  end
  
  def reset_new_posting_comment_form(page)
    page['#postings .posting:first-child .posting_comment button[type=submit]'].button({:icons => { :primary => 'ui-icon-check' }})
    page['#postings .posting:first-child .posting_comment button.cancel'].button({:icons => { :primary => 'ui-icon-close' }})
    page['ul#tabs li.current'].removeClass('current')
  end
  
  def link_to_unread_messages
    if current_user
      unread_conversations_count = current_user.conversations.site(current_site).chatty.unread.count
      link_to(unread_conversations_count, inbox_path, :class => 'unread') if unread_conversations_count > 0
    end
  end
  
  def link_to_unread_messages_unless_inbox
    unless [ inbox_path, wave_conversations_path ].detect{ |path| current_page?(path) }.present?
      link_to_unread_messages
    end
  end
end
