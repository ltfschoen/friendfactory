class Invitation::Base < ActiveRecord::Base

  set_table_name 'invitations'

  belongs_to :user, :class_name => 'Personage'
  validates_presence_of :user

  scope :site, lambda { |site|
      joins(:user => :user).
      where(:personages => { :users => { :site_id => site.id }})
  }

end