module Admin::SitesHelper

  def site_with_empty_fields(site)
    site.tap do |site|
      site.images.build
      site.constants.build
      site.texts.build
      site.stylesheets.build if site.stylesheets.length == 0
      site.biometric_domains.build if site.biometric_domains.length == 0
    end
  end
  
  def home_waves(site)
    (persona_waves(site) + community_waves(site)).uniq
  end
  
  private
  
  def persona_waves(site)
    site.waves.published.joins(:user => :role).where(:roles => { :name => [ :ambassador, :place ]})
  end
  
  def community_waves(site)
    site.waves.type(Wave::Community).published
  end

end
