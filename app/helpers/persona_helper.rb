module PersonaHelper
  def render_headshot(persona, opts = {})
    render :partial => 'persona/base', :locals => { :persona => persona }.merge(opts)  
  end
end
