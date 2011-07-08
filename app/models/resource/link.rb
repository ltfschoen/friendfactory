require 'open-uri'

class Resource::Link < ActiveRecord::Base
  set_inheritance_column nil

  attr_reader :images

  has_many :embeds,
      :class_name  => 'Resource::Embed',
      :foreign_key => 'resource_link_id' do
    def primary
      where(:primary => true).order('`resource_embeds`.`id` asc').limit(1).first
    end
  end

  def embedify
    api = Embedly::API.new(:key => EmbedlyKey)
    response = api.preview(:url => url, :maxwidth => 800).first
    if response.try(:error_code).nil?
      response = response.marshal_dump
      response.except(:object, :images, :embeds, :place, :event).each do |key, value|
        send("#{key}=", value) rescue nil
      end
      primary_embed = response[:object].present? ? response[:object].merge(:primary => true) : nil
      build_embeds([ primary_embed ] + response[:embeds])
      download_images(response[:images])
      true
    end
  # rescue
  #   nil
  end
    
  private
  
  def build_embeds(new_embeds)
    new_embeds.each do |embed|
      if embed.present?
        embeds.build(embed)
      end
    end
  end
  
  def download_images(image_urls)
    @images = image_urls.map do |image_url|
      download_image(image_url.to_options[:url])
    end.compact
  end
  
  def download_image(image_url)
    io = open(URI.parse(image_url), :redirect => true)
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue
    nil
  end

end
