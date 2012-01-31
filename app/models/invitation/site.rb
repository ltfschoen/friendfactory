class Invitation::Site < Invitation::Base

  attr_accessible :code
  validates_presence_of :code

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

  def acceptable?
    false
  end

end