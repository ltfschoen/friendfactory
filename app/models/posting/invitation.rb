class Posting::Invitation < Posting::Base
  
  alias_attribute :site, :resource
  alias_attribute :code, :subject
  alias_attribute :email, :body
  alias_attribute :sponsor, :user

  belongs_to :invitee, :foreign_key => 'body', :primary_key => 'email', :class_name => 'User'

  validates_presence_of :code, :site, :sponsor
  
  state_machine do
    state :offered
    state :accepted
    state :rejected
    state :retracted
    
    event :offer do
      transitions :to => :offered, :from => [ :unpublished ], :on_transition => :deliver_invitation_mail
    end
    
    event :accept do
      transitions :to => :accepted, :from => [ :offered ]
    end
    
    event :reject do
      transitions :to => :rejected, :from => [ :offered ]
    end

    event :retract do
      transitions :to => :retracted, :from => [ :offered, :accepted ]
    end    
  end
  
  def self.find_all_by_code(code)
    find_all_by_subject(code)
  end
  
  def deliver_invitation_mail
    InvitationsMailer.new_invitation_mail(self).deliver
  end
  
end
