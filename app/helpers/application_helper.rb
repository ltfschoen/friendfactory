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
    files.map!{ |file| File.join(current_site.name, file) }
    content_for(:head) do
      javascript_include_tag(*files)
    end
  end
  
  def stylesheet(*files)
    files.map!{ |file| File.join(current_site.name, file) }
    content_for(:head) do
      stylesheet_link_tag(*files)
    end
  end
  
  def image_tag(source, opts = {})    
    source = File.join(current_site.name, source) unless opts.delete(:factory_image) == true
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
  
end