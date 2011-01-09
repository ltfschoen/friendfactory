class UserInfo < ActiveRecord::Base

  GuyGender    = 1
  GirlGender   = 2
  TrannyGender = 3

  Gender =
      ([ 'Guy', 'Girl', 'Trans' ].zip([ GuyGender, GirlGender, TrannyGender ]))

  Orientation =
      (a = [ 'Gay', 'Lesbian', 'Straight', 'Bisexual', 'Trans' ]).zip((1..a.length).to_a)
			
	Relationship = 
	    (a = [ 'Single', 'In a Relationship', 'Married', 'Looking for a Relationship', 'Friends Only' ]).zip((1..a.length).to_a)
	    
	Deafness =
	    (a = [ 'Deaf', 'Hard of Hearing', 'Hearing', 'CODA' ]).zip((1..a.length).to_a)

  set_table_name 'user_info'

  acts_as_taggable

  belongs_to :user
  has_one :profile, :as => :resource, :class_name => 'Wave::Profile'
  
  before_save do |user_info|
    self.tag_list = [
      user_info.gender_description.try(:downcase),
      user_info.orientation_description.try(:downcase),
      user_info.relationship_description.try(:downcase),
      user_info.deafness_description.try(:downcase),
      UserInfo.scrub_tag(user_info.location_description)
    ].compact * ', '
    true
  end
  
  after_save do |user_info|
    profile = user_info.profile
    if profile.present?
      profile.touch
    end
    true
  end
  
  def gender_description
    Gender.rassoc(self[:gender]).try(:first)
  end
  
  def orientation_description
    Orientation.rassoc(self[:orientation]).try(:first)
  end

  def relationship_description
    Relationship.rassoc(self[:relationship]).try(:first)
  end
  
  def deafness_description
    Deafness.rassoc(self[:deafness]).try(:first)
  end
  
  def birthday_description
    self.dob.strftime('%e %B') if self.dob.present?
  end
  
  def location_description
    self.location
  end
  
  private
  
  def self.scrub_tag(tag)
    unless tag.blank?
      tag = scrub_transposes(scrub_rejects(scrub_punctuation(tag)))
      tag.nil? || (tag.length > 16) ? nil : tag.downcase
    end
  end
  
  def self.scrub_punctuation(tag)
    tag.gsub(/,/, ' ').gsub(/'|"|\.|-/, '').gsub(/\s{2,}/, ' ')
  end
  
  def self.scrub_rejects(tag)
    rejects = Admin::Tag.where(['taggable_type = ? and corrected is null', 'UserInfo']).map(&:defective)
    tag.gsub(/\b(#{rejects * '|'})\b/i, '')
  end
  
  def self.scrub_transposes(tag)
    Admin::Tag.where(['taggable_type = ? and corrected is not null', 'UserInfo']).each do |transpose|
      tag = tag.gsub(/\b#{transpose.defective}\b/i, transpose.corrected)
    end
    tag
  end

end
