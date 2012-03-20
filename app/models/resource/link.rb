require 'open-uri'

class Resource::Link < ActiveRecord::Base

  set_inheritance_column nil

  attr_accessible \
      :url,
      :title,
      :description

  has_many :embeds,
      :class_name  => 'Resource::Embed',
      :foreign_key => 'resource_link_id' do
    def primary
      where(:primary => true).order('`resource_embeds`.`id` ASC').limit(1).first
    end
  end

  def embedify
    api = Embedly::API.new(:key => EmbedlyKey)
    if response = api.preview(:url => url, :maxwidth => 310).first
      response = response.marshal_dump
      assign_attributes(response)
      build_embeds(response)
      download_images(response)
      true
    end
  rescue
    false
  end

  def images
    @images || []
  end

  private

  def assign_attributes(response)
    response.except(:object, :images, :embeds, :place, :event).each do |key, value|
      send("#{key}=", value) rescue nil
    end
  end

  def build_embeds(response)
    primary_embed = response[:object].present? ? response[:object].merge(:primary => true) : nil
    ([ primary_embed ] + response[:embeds]).flatten.compact.each do |embed|
        embeds.build(embed)
    end
  end

  def download_images(response)
    if image_urls = response[:images]
      @images = image_urls.map do |image_url|
        download_image(image_url.to_options[:url])
      end.compact
    end
  end

  def download_image(image_url)
    io = open(URI.parse(image_url), :redirect => true)
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
    nil
  end

end
