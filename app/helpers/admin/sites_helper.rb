module Admin::SitesHelper

  def site_with_empty_assets_and_stylesheet(site)
    site.tap do |site|
      site.images.build
      site.constants.build
      site.texts.build
      site.stylesheets.build if site.stylesheets.length == 0
    end
  end

end
