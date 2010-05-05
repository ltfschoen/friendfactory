module ApplicationHelper

  attr_reader :current_layout
  
  def form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    super(record_or_name_or_array, *(args << options.merge(:builder => ButtonFormBuilder)), &proc)    
  end

  def remote_form_for(record_or_name_or_array, *args, &proc)
    options = args.extract_options!
    super(record_or_name_or_array, *(args << options.merge(:builder => ButtonFormBuilder)), &proc)    
  end
  
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
  def stylesheet(*files)
    files.map! { |file| File.join(current_site.name, file) }
    content_for(:head) { stylesheet_link_tag(*files) }
  end
  
  def image_tag(source, opts = {})    
    source = File.join(current_site.name, source) unless opts.delete(:site) == false
    super(source, opts)
  end
  
  def fixed_container
    content_for(:current_container, 'container_16_fixed')
    content_for(:head, stylesheet_link_tag(File.join('960gs', 'fixed'), :media => 'screen'))
  end

  def fluid_container
    content_for(:current_container, 'container_16')
  end
  
  def sidebar
    render(:partial => "layouts/#{current_site}/sidebar")
  end
  
  def gutter
    render(:partial => "layouts/#{current_site}/gutter")
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
    image_tag('ajax-loader.gif', :size => size, :class => 'spinner', :id => 'spinner', :style => 'display:none')
  end
  
  def link_to_profile(user)
    link_to(user.full_name, profile_path(user.profile), :class => 'profile') if user.profile
  end
  
  def portrait_image_tag(avatar)
    css = [
        'avatar',
        'avatar_portrait',
        avatar.user.online? ? 'online' : nil ].compact * ' '
    image_tag(avatar.image.url(:portrait), :class => css, :site => false) unless avatar.nil?
  end
  
  def thumb_image_tag(avatar, opts = {})
    klass = [
        'avatar',
        'avatar_thumb',
        avatar.user.online? ? 'online' : nil,
        opts[:class] ].compact * ' '
    image_tag(avatar.image.url(:thumb), :class => klass, :site => false) unless avatar.nil?
  end
  
  def distance_of_time_in_words_to_now(date)
    content_tag(:span, :class => 'distance_of_time') do
      returning String.new do |html|
        html << super(date)
        html << '&nbsp;ago'
      end
    end
  end
    
end
