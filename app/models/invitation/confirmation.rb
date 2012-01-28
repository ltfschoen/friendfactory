class Invitation::Confirmation < ActiveRecord::Base

  set_table_name 'invitation_confirmations'

  belongs_to :invitation,
      :foreign_key => 'invitation_id',
      :class_name  => 'Invitation::Base'

  belongs_to :friendship,
      :foreign_key => 'friendship_id',
      :class_name  => 'Friendship::Invitation'

  belongs_to :invitee,
      :foreign_key => 'invitee_id',
      :class_name  => 'Personage'

  validates_presence_of :invitation, :invitee

end
