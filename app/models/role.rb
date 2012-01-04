class Role < ActiveRecord::Base

  validates_presence_of :name, :display_name
  validates_presence_of :default_profile_type
  validates_presence_of :default_persona_type

  has_many :users

  def self.default
    where(:name => 'user').limit(1).first
  end

end