module RenderHeadshot

  def render_headshot(profile_id, opts = {})
    if personage = Personage.enabled.site(current_site).includes(:persona => :avatar).find_by_profile_id(profile_id)
      render :partial => File.join('personages', personage.persona_type, 'headshot'), :locals => { :personage => personage }.merge(opts)
    end
  end

end