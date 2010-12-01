module ApplicationHelper
  
  def current_layout    
    controller_name.singularize
  end

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
    files.map! { |file| File.join(current_site.name,*file) }
    content_for(:stylesheets) { stylesheet_link_tag(files) }
  end
  
  def image_tag(source, opts = {})    
    source = File.join(current_site.name, source) unless opts.delete(:site) == false
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
    image_tag('ajax-loader.gif', :size => size, :class => css_class, :id => opts[:id], :site => false)
  end
  
  def link_to_profile(user, opts = {})
    name = opts[:label] || user.first_name
    if user.profile
      link_to(name, waves_profile_path(user.profile), :class => 'profile', :rel => '#polaroid-overlay')
    end
  end

  def link_to_bio(opts = {})
    label = opts[:label] || 'Bio'
    # TODO link_to(name, profile_path(user.profile), :class => 'profile') if user.profile
    content_tag(:span, label, :class => 'bio')
  end
    
  def distance_of_time_in_words_to_now(date, opts = {})
    suffix = opts[:suffix] || 'ago'
    prefix = opts[:prefix]
    content_tag(:span, :class => 'distance_of_time') do
      returning String.new do |html|
        html << "#{prefix}&nbsp;" if prefix.present?
        html << super(date)
        html << "&nbsp;#{suffix}" if suffix.present?
      end
    end
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

end
