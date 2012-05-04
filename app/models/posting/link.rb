require 'primed_at'

class Posting::Link < Posting::Base

  include PrimedAt

  attr_writer :url

  attr_accessible \
      :url,
      :subject,
      :body,
      :resource_attributes

  validates_presence_of :user, :resource

  delegate \
      :original_url,
      :display_url,
      :title,
      :description,
      :author_name,
      :author_url,
      :provider_name,
      :provider_display,
      :provider_url,
      :embeds,
    :to => :resource

  belongs_to :resource,
      :class_name => 'Resource::Link',
      :foreign_key => 'resource_id'

  accepts_nested_attributes_for :resource

  after_validation :set_user_id_on_photos

  subscribable :comment, :user

  def url
    resource.present? ? resource.url : @url
  end

  def embedify
    if build_resource(:url => url).embedify
      build_photos
      self
    else
      false
    end
  end

  def photos
    children.type(Posting::Photo)
  end

  private

  def set_user_id_on_photos
    photos.each { |photo| photo.user_id = self.user_id }
  end

  def resource_attributes=(attrs)
    resource.present? ? resource.update_attributes(attrs) : build_resource(attrs)
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

end
