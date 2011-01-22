class ButtonFormBuilder < ActionView::Helpers::FormBuilder

  include PlaceholderTextHelper
  
  def submit(label, opts = {})
    if opts.delete(:as_button) == false
      @template.submit_tag(label, opts)
    else
      @template.content_tag(:button, label, opts.merge(:type => 'submit'))
    end
  end
    
  def button(label, *args)
    opts = args.extract_options!
    if href = args.first
      opts.merge!(:href => href)
    end
    @template.content_tag(:button, label, opts)
  end
  
  # def text_field(label, opts = {})
  #   opts.merge!(:placeholder => placeholder(opts[:placeholder], label))
  #   super(label, opts)
  # end
  
  # def password_field(label, opts = {})    
  #   opts.merge!(:placeholder => placeholder(opts[:placeholder], label))
  #   super(label, opts)
  # end

  private
  
  def placeholder(placeholder, label)
    case placeholder
    when false  # No placeholder
      nil
    when nil    # Lookup       
      placeholder_for(label.to_sym)
    when String # Explicitly set
      placeholder
    end
  end
    
end