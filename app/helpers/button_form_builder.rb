class ButtonFormBuilder < ActionView::Helpers::FormBuilder

  include PlaceholderTextHelper

  DateName = Struct.new(:date, :day_name)

  # def submit(label, opts = {})
  #   button = opts.delete(:button)
  #   if button.present? && button == true
  #     @template.content_tag(:button, label, opts.merge(:type => 'submit'))
  #   else
  #     @template.submit_tag(label, opts)
  #   end
  # end

  def button(label, *args)
    opts = args.extract_options!
    if href = args.first
      opts.merge!(:href => href)
    end
    @template.content_tag(:button, label, opts)
  end

  def cancel(label = nil)
    label ||= 'Cancel'
    @template.content_tag(:input, nil, :type => 'button', :value => label, :class => 'cancel')
  end

  def sticky_until
    @template.content_tag(:span, :class => 'sticky_until') do |html|
      html = "Sticky&nbsp;until&nbsp;".html_safe
      html << collection_select(:sticky_until, day_names_from_today, :date, :day_name, :include_blank => true)
    end
  end

  def resolve(resolver)
    @template.hidden_field_tag :resolver, resolver, :id => nil
  end

  def existing_user_password_confirmation_field(attribute, *args)
    opts = args.extract_options!
    current_site = opts.delete(:current_site)
    if @object.new_record? || (@object.existing_record? && @object.site_ids.include?(current_site.id))
      style = 'display:none'
    end
    opts.merge!({ :style => style, :id => 'reuse_password' })
    @template.content_tag(:div, "Use your #{@template.content_tag(:span, 'FriskyFactory')} password".html_safe, opts)
  end

  def new_user_password_confirmation_field(attribute, *args)
    opts = args.extract_options!
    current_site = opts.delete(:current_site)
    if @object.existing_record? && !@object.site_ids.include?(current_site.id)
      style = 'display:none'
    end
    password_field(attribute, opts.merge({ :style => style }))
  end

  private

  def day_names_from_today
    today = Date.today
    1.upto(6).inject([]) do |memo, num|
      date = today + num.days
      memo << DateName.new(date, date.strftime("%A"))
    end
  end
end