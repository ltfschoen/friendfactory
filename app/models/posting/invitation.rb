class Posting::Invitation < Posting::Base
  
  FIRST_REMINDER_AGE  = 1.day
  SECOND_REMINDER_AGE = 3.days
  THIRD_REMINDER_AGE  = 7.days
  EXPIRATION_AGE      = 8.days
  
  alias_attribute :site, :resource
  alias_attribute :code, :subject
  alias_attribute :email, :body
  alias_attribute :sponsor, :user

  belongs_to :invitee, :foreign_key => 'body', :primary_key => 'email', :class_name => 'User'

  validates_presence_of :site, :sponsor
  
  after_create do |invitation|    
    invitation.code ||= invitation.id
    invitation.save!
  end
  
  after_update do |invitation|    
    invitation.deliver_mail if invitation.needs_redelivery?
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
    state :expired
    
    event :offer do
      transitions :to => :offered, :from => [ :unpublished ], :on_transition => :deliver_mail
    end
    
    event :accept do
      transitions :to => :accepted, :from => [ :offered, :accepted ]
    end    
    
    event :expire do
      transitions :to => :expired, :from => [ :offered ]
    end
  end
  
  scope :offered, where(:state => :offered)
  scope :days_old, lambda { |age| offered.where('created_at >= ? and created_at < ?', Date.today - (age + 1.day), Date.today - age) }
  scope :expiring, lambda { offered.where('created_at < ?', Date.today - EXPIRATION_AGE) }

  def self.find_all_by_code(code)
    find_all_by_subject(code)
  end

  def self.redeliver_mail
    redeliver_aging_mail + redeliver_expiring_mail
  end

  def email=(new_email)
    if new_email != self.email
      write_attribute(:body, new_email)
      self.needs_redelivery = true
    end
  end
  
  def anonymous?
    email.blank?
  end
    
  def deliver_mail
    if email.present?
      InvitationsMailer.new_invitation_mail(self).deliver
      self.needs_redelivery = false
    end
  end
  
  def needs_redelivery=(value)
    @needs_redelivery = value
  end
  
  def needs_redelivery?
    @needs_redelivery && offered?
  end
  
  private
  
  def self.redeliver_aging_mail
    count = 0
    [ FIRST_REMINDER_AGE, SECOND_REMINDER_AGE, THIRD_REMINDER_AGE ].each do |age|
      days_old(age).each do |invitation|
        InvitationsMailer.new_invitation_mail(invitation).deliver && count += 1        
      end
    end    
    count
  end
  
  def self.redeliver_expiring_mail
    count = 0
    expiring.each do |invitation|
      InvitationsMailer.new_invitation_mail(invitation).deliver && count += 1      
    end
    count
  end
    
end
