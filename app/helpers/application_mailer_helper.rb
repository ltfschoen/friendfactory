module ApplicationMailerHelper

  def mailer_image_tag(source, site, host, opts = {})
    image_tag(mailer_image_url(source, site, host), opts)
  end

  def mailer_image_url(source, site, host)
    if asset = site.assets.type(Asset::Image).find_by_name(File.basename(source, '.*'))
      source = asset.url(:original)
    else
      source = path_to_image(File.join('mailers', source))
    end
    full_url(File.join(host, source))
  end

  def protocol
    "http://"
  end

  def full_url(host, path = nil)
    "#{protocol}#{host}#{path}"
  end

  def render_featured_personages(personages)
    render :partial => 'layouts/shared/featured_personages', :object => personages
  end

end
