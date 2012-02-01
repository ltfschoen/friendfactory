class Invitation::Personal < Invitation::Base

  attr_accessible :email
  validates_presence_of :email

  attr_accessible :code
  validates_presence_of :code, :on => :update

  state_machine do
    event :accept do
      transitions :to => :accepted, :from => [ :offered ], :on_transition => [ :create_confirmation_and_friendship_with_invitee_personage ]
    end
  end

  has_one :confirmation,
      :foreign_key => 'invitation_id',
      :class_name  => 'Invitation::Confirmation'

  has_one :friendship, :through => :confirmation

  after_create :initialize_code

  def confirmations_count
    confirmation.present? ? 1 : 0
  end

  def create_confirmation_and_friendship_with_invitee_personage
    if confirmation = build_confirmation(:invitee => invitee_personage)
      friendship = Friendship::Invitation.new(:friend => invitee_personage)
      friendship.invitation_confirmation = confirmation
      user.friendships << friendship
    end
  end

  private

  def initialize_code
    if code.nil?
      self[:code] = self[:id]
      save
    end
    true
  end

end
