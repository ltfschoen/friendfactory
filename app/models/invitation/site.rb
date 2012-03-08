class Invitation::Site < Invitation::Base

  attr_accessible :code
  validates_presence_of :code
  validates_uniqueness_of :code

  state_machine do
    state :offered
    state :accepted
    state :expired

    event :accept do
      transitions :to => :offered, :from => [ :offered ], :on_transition => [ :create_confirmation_and_friendship_with_invitee_personage ]
    end

    event :expire do
      transitions :to => :expired, :from => [ :offered ]
    end
  end

  validates_length_of :email,
      :is => 0,
      :message => 'not allowed for site invitations',
      :allow_blank => true

  has_many :confirmations,
      :foreign_key => 'invitation_id',
      :class_name  => 'Invitation::Confirmation'

  has_many :friendships, :through => :confirmations

  def confirmations_count
    confirmations.count
  end

  def create_confirmation_and_friendship_with_invitee_personage
    if confirmation = confirmations.build(:invitee => invitee_personage)
      friendship = Friendship::Invitation.new(:friend => invitee_personage)
      friendship.invitation_confirmation = confirmation
      user.friendships << friendship
    end
  end

end