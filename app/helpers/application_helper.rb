# encoding: utf-8

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

  def sid
    { :class => current_site.name } if current_site.present?
  end

  def uid(id = nil)
    id = current_user.id if id.nil? && current_user.present?
    { :class=> User.uid(id) }
  end

  def gid
    { :class => current_user.gid } if current_user.present?
  end

  def link_to_unpublish(posting)
    link_to "×", unpublish_posting_path(posting), :title => 'Remove', :class => 'remove', :rel => '#unpublish_overlay'
  end
end
