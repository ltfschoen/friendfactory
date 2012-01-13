module HeadshotHelper
  def render_headshot(personage)
    render :partial => File.join('headshots', personage.type, 'headshot'), :locals => { :personage => personage }
  end

  def headshot_image_tag(persona, opts = {})
    opts.merge!(:size => '190x190', :alt => persona.handle, :title => persona.handle)
    image_tag(persona.avatar.url(:polaroid), opts)
  end
end
