class Invitation::Personal < Invitation::Base

  attr_accessible :email
  validates_presence_of :email

  attr_accessible :code
  validates_presence_of :code, :on => :update

  has_one :confirmation,
      :foreign_key => 'invitation_id',
      :class_name  => 'Invitation::Confirmation'

  has_one :friendship, :through => :confirmation

end
