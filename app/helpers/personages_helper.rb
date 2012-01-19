module PersonagesHelper

  def render_headshot(personage, opts = {})
    render :partial => File.join('personages', personage.persona_type, 'headshot'), :locals => { :personage => personage }.merge(opts)
  end

  def headshot_image_tag(persona, opts = {})
    opts.merge!(:size => '190x190', :alt => persona.handle, :title => persona.handle)
    image_tag(persona.avatar.url(:polaroid), opts)
  end

  def build_empty_personage(personage)
    personage.build_persona
    personage
  end

  def personage_options_for_select
    Persona::Base.types.map { |p| [ p.demodulize, p ] }.sort_by { |p| p.first }
  end

end
