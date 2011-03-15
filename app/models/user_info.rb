require 'tag_scrubber'

class UserInfo < ActiveRecord::Base

  include TagScrubber
  
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
    tag_list = [
      user_info.gender_description,
      user_info.orientation_description,
      user_info.deafness_description
    ].compact * ','
    
    if location_tags = scrub_tag(user_info.location_description)
      if tag_list.present?
        tag_list += (',' + location_tags)
      else
        tag_list = location_tags
      end
    end
    
    self.tag_list = tag_list
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

end
