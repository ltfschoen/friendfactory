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

  def home_users(site)
    Personage.homeable(site).enabled.includes(:profile).includes(:persona).sort_by{ |p| p.display_name }
  end

end
