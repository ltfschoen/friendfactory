require 'empty_avatar'

class Persona::Base < ActiveRecord::Base

  set_table_name 'personas'

  class_attribute :default_profile_type
  self.default_profile_type = 'Wave::Base'

  attr_accessible \
      :handle,
      :avatar,
      :default

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
