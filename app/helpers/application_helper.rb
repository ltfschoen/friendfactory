module ApplicationHelper

  attr_reader :current_layout
  
  def form_for(record_or_name_or_array, *args, &proc)
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
    super(File.join(current_site.name, source), opts)
  end
  
  def fixed_container
    content_for(:current_container, 'container_16_fixed')
    content_for(:head, stylesheet_link_tag(File.join('960gs', 'fixed'), :media => 'screen'))
  end

  def fluid_container
    content_for(:current_container, 'container_16')
  end  
  
end