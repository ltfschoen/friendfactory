class Invitation::Confirmation < ActiveRecord::Base

  self.table_name = "invitation_confirmations"

  attr_accessible :invitee

  belongs_to :invitation,
      :foreign_key => 'invitation_id',
      :class_name  => 'Invitation::Base'

  belongs_to :invitee,
      :foreign_key => 'invitee_id',
      :class_name  => 'Personage'

  belongs_to :friendship,
      :foreign_key => 'friendship_id',
      :class_name  => 'Friendship::Invitation'

  validates_presence_of :invitation, :invitee

end
