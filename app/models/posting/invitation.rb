class Posting::Invitation < Posting::Base

  FIRST_REMINDER_AGE  = 1.day
  SECOND_REMINDER_AGE = 7.days
  EXPIRATION_AGE      = 10.days
  
  belongs_to :site, :foreign_key => 'resource_id'
  belongs_to :invitee, :foreign_key => 'body', :primary_key => 'email', :class_name => 'User'

  alias_attribute :code, :subject
  alias_attribute :email, :body
  alias_attribute :sponsor, :user

  validates_presence_of :site, :sponsor

  after_create do |invitation|
    invitation.code ||= invitation.id
    invitation.save!
  end

  state_machine do
    state :offered
    state :accepted
    state :expired
    
    event :offer do
      transitions :to => :offered, :from => [ :unpublished ]
    end
    
    event :accept do
      transitions :to => :accepted, :from => [ :offered, :accepted ]
    end    
    
    event :expire do
      transitions :to => :expired, :from => [ :offered ]
    end
    
    event :unpublish do
      transitions :to => :unpublished, :from => [ :offered, :expired ]
    end
  end

  scope :offered, where(:state => :offered)
  scope :personal, where('`postings`.`body` IS NOT NULL')
  scope :universal, where(:body => nil)
  scope :code, lambda { |code| where(:subject => code) }

  scope :age, lambda { |*days_old|
    where_clause = days_old.inject([[]]) do |memo, age|
      memo.first << [ '(`postings`.`created_at` >= ? AND `postings`.`created_at` < ?)' ]
      memo << [ Date.today.at_midnight - (age + 1.day), Date.today.at_midnight - age ]
      memo
    end
    where(*[ where_clause.shift.join(' OR '), where_clause ].flatten)
  }

  scope :not_redundant, lambda {
    joins('LEFT OUTER JOIN `users` ON `postings`.`body` = `users`.`email`').
    where('`users`.`id` IS NULL') }

  scope :redundant, lambda {
    joins('LEFT OUTER JOIN `users` ON `postings`.`body` = `users`.`email`').
    where('`users`.`id` IS NOT NULL') }

  scope :aging, lambda {
    age(FIRST_REMINDER_AGE, SECOND_REMINDER_AGE).
    order('`postings`.`created_at` ASC') }

  scope :expiring, lambda {
    age(EXPIRATION_AGE).
    order('`postings`.`created_at` ASC') }

  def self.find_by_code(code)
    order('`postings`.`created_at` DESC').find_by_subject(code)
  end

  def email=(new_email)
    if new_email != self.email
      write_attribute(:body, new_email)
      set_email_changed unless new_record?
    end
  end

  alias :body= :email=

  def email_changed?
    @email_changed
  end

  def anonymous?
    email.blank?
  end

  private

  def set_email_changed
    @email_changed = true
  end    
end
