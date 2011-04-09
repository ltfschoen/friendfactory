class Posting::Invitation < Posting::Base
  
  alias_attribute :site, :resource
  alias_attribute :code, :subject
  alias_attribute :email, :body
  alias_attribute :sponsor, :user

  attr_reader :redeliver_invitation_mail
  
  belongs_to :invitee, :foreign_key => 'body', :primary_key => 'email', :class_name => 'User'

  validates_presence_of :site, :sponsor
  
  after_create do |invitation|    
    invitation.code ||= invitation.id
    invitation.offer!
  end
  
  after_update do |invitation|
    if invitation.redeliver_invitation_mail
      deliver_invitation_mail
    end
  end
  
  def distribute(sites)
    sites.each do |site|
      if profile = user.profile(site)
        profile.postings << self
      end
    end
    super
  end

  state_machine do
    state :offered
    state :accepted
    
    event :offer do
      transitions :to => :offered, :from => [ :unpublished ], :on_transition => :deliver_invitation_mail
    end
    
    event :accept do
      transitions :to => :accepted, :from => [ :offered, :accepted ]
    end    
  end

  def email=(new_email)
    if new_email != self.email
      write_attribute(:body, new_email)
      @redeliver_invitation_mail = true
    end
  end
  
  def anonymous?
    email.blank?
  end
  
  def self.find_all_by_code(code)
    find_all_by_subject(code)
  end
  
  def deliver_invitation_mail
    if email.present?
      InvitationsMailer.new_invitation_mail(self).deliver
      @redeliver_invitation_mail = false
    end
  end
    
end
