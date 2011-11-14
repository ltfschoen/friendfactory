module AssetHelper
  def asset_image_tag(variable_name, opts = {})
    if asset = current_site.assets[variable_name]
      image_tag asset.url, opts
    end
  end
end
