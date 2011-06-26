class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :wave, :class_name => 'Wave::Base'

  def read
    @last_read_at = updated_at
    touch
    self
  end

  alias_attribute :read_at, :updated_at

  def last_read_at
    @last_read_at || updated_at
  end
  
end
