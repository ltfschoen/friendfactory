module PersonagesHelper

  def render_headshot(personage, opts = {})
    render :partial => File.join('personages', personage.persona_type, 'headshot'), :locals => { :personage => personage }.merge(opts)
  end

  def headshot_image_tag(persona, opts = {})
    if persona && persona.avatar
      opts.merge!(:size => '190x190', :alt => persona.handle, :title => persona.handle)
      image_tag(persona.avatar.url(:polaroid), opts)
    elsif persona
      Rails.logger.warn "Persona:#{persona.id} has no avatar"
      content_tag(:span, "&nbsp;".html_safe, :class => 'headshot-with-error', :style => 'display:inline-block;width:190px;height:190px;')
    end
  end

  def build_empty_personage(personage)
    personage.build_persona
    personage
  end

  def personage_options_for_select
    Persona::Base.types.map { |p| [ p.demodulize, p ] }.sort_by { |p| p.first }
  end

  def poke_css_class(personage_id)
    if current_user && current_user[:id] != personage_id
      current_user.has_poked?(personage_id) && 'poked'
    end
  end

  def link_to_send_cocktail(personage)
    if current_user && (current_user[:id] != personage[:id])
      handle = personage.handle
      handle = nil if handle.length > 7
      msg    = [ 'Send', handle, 'a Cocktail']

      if current_user.has_poked?(personage[:id])
        msg = msg.unshift("Don't")
        disable_with = "Trashing cocktail..."
      else
        disable_with = "Sending cocktail..."
      end

      link_to(msg.compact.join(' '), profile_friendships_path(personage, :type => 'poke'),
          :class => 'poke', :remote => true, :method => :post, :'data-type' => :json, :'data-disable-with' => disable_with)
    end
  end

  def show_or_edit_headshot_pane(personage, pane)
    persona_type, pane = pane.split('/')
    action = (params[:pane] == pane) || params[:pane].blank? ? 'edit' : 'show'
    render :partial => File.join('personages', persona_type, "#{action}_#{pane}"), :locals => { :personage => personage }
  end

end
