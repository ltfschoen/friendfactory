class Friendship::Invitation < Friendship::Base

  has_one :invitation_confirmation,
      :foreign_key => 'friendship_id',
      :class_name  => 'Invitation::Confirmation'

  has_one :invitation, :through => :invitation_confirmation

end