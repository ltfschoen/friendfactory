class Bookmark < ActiveRecord::Base
  belongs_to :user
  belongs_to :wave, :class_name => 'Wave::Base'

  def read
    @last_read_at = read_at
    update_attribute(:read_at, Time.now.utc)
    self
  end

  def last_read_at
    defined?(@last_read_at) ? @last_read_at : read_at
  end
end
