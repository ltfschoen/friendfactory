class Posting::Link < Posting::Base

  attr_writer :url

  attr_accessible :url, :subject, :body

  validates_presence_of :user, :resource

  belongs_to :resource, :class_name => 'Resource::Link', :foreign_key => 'resource_id'

  after_validation :set_user_id_on_photos

  delegate :original_url, :display_url, :title, :description, :author_name, :author_url, :provider_name, :provider_display, :provider_url, :embeds,
      :to => :resource

  def url
    resource.try(:url) || @url
  end

  def embedify
    build_resource(:url => url).embedify
  end

  def photos
    children.type(Posting::Photo)
  end

  def build_photos
    if resource.present?
      resource.images.each do |image|
        children << Posting::Photo.new(:image => image) do |posting|
          posting.state = :published
        end
      end
    end
  end

  private

  def set_user_id_on_photos
    photos.each { |photo| photo.user_id = self.user_id }
  end

end
