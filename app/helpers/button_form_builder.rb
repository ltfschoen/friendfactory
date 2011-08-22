class ButtonFormBuilder < ActionView::Helpers::FormBuilder

  include PlaceholderTextHelper

  DateName = Struct.new(:date, :day_name)
  
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
  
  def sticky_until
    @template.content_tag(:span, "Sticky&nbsp;until&nbsp;".html_safe) +
      collection_select(:sticky_until, day_names_from_today, :date, :day_name, :include_blank => true)
  end
  
  def existing_user_password_label(attribute, label, *args)
    opts = args.extract_options!
    css_class = opts[:class] || ''
    if @object.new_record? || (@object.existing_record? && @object.site_ids.include?(opts[:current_site].id))
      css_class = [ css_class, 'hidden' ].compact * ' '
    end
    label(attribute, label, opts.merge(:class => css_class))
  end
  
  def new_user_password_confirmation_field(attribute, label, *args)
    opts = args.extract_options!
    label_css_class = 'placeholder'
    password_field_css_class = opts[:class] || ''
    if @object.existing_record? && !@object.site_ids.include?(opts[:current_site].id)
      label_css_class = [ label_css_class, 'hidden' ] * ' '
      password_field_css_class = [ password_field_css_class, 'hidden' ].compact * ' '      
    end
    label(attribute, label, :class => label_css_class) +
    password_field(attribute, opts.merge(:class => password_field_css_class))
  end
  
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
  
  def day_names_from_today
    today = Date.today
    1.upto(6).inject([]) do |memo, num|
      date = today + num.days
      memo << DateName.new(date, date.strftime("%A"))
    end
  end
end