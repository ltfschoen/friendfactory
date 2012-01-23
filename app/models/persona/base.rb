require 'empty_avatar'

class Persona::Base < ActiveRecord::Base

  set_table_name 'personas'

  class_attribute :default_profile_type
  self.default_profile_type = 'Wave::Base'

  acts_as_taggable
  acts_as_taggable_on :locations, :biometrics

  attr_accessible \
      :handle,
      :avatar,
      :default

  before_save :set_tag_list

  def set_tag_list
    # Override in inherited classes
  end

  private :set_tag_list

  has_one :user,
      :class_name  => 'Personage',
      :foreign_key => 'persona_id'

  belongs_to :avatar,
      :class_name => 'Posting::Avatar',
      :conditions => { :state => :published }

  scope :type, lambda { |*types|
      where(:type => types.map { |type| "Persona/#{type}".camelize })
  }

  scope :has_avatar, where('`avatar_id` is not null')

  def handle
    self[:handle].strip if self[:handle].present?
  end

  def avatar?
    avatar_id.present?
  end

  def avatar_with_silhouette
    avatar? ? avatar_without_silhouette : EmptyAvatar.new(self)
  end

  alias_method_chain :avatar, :silhouette

end
