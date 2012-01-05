require 'empty_avatar'

class Persona::Base < ActiveRecord::Base

  set_table_name 'personas'

  attr_accessible \
      :handle,
      :avatar_id

  belongs_to :user

  has_one :profile,
      :class_name  => 'Wave::Profile',
      :foreign_key => 'resource_id'

  belongs_to :avatar,
      :class_name => 'Posting::Avatar',
      :conditions => { :state => :published }

  def handle
    self[:handle].strip if self[:handle].present?
  end

  def avatar?
    avatar.present?
  end

  def avatar_with_silhouette
    avatar_without_silhouette || EmptyAvatar.new(self)
  end

  alias_method_chain :avatar, :silhouette

end
