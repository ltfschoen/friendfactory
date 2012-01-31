class Invitation::Personal < Invitation::Base

  attr_accessible :email
  validates_presence_of :email

  attr_accessible :code
  validates_presence_of :code, :on => :update

  has_one :confirmation,
      :foreign_key => 'invitation_id',
      :class_name  => 'Invitation::Confirmation'

  has_one :friendship, :through => :confirmation

  after_create :initialize_code

  def confirmations_count
    confirmation.present? ? 1 : 0
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
