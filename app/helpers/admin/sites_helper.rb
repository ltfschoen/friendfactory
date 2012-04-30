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
    Personage.homeable(site).includes(:profile).includes(:persona).sort_by{ |p| p.display_name }
  end

  def site_logo_image_tag(site)
    if site && asset = site.assets.type(Asset::Image).find_by_name(File.basename('logo', '.*'))
      image_tag(asset.url(:original))
    end
  end

end
