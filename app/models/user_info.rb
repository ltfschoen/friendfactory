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

  belongs_to :user  
  has_one :profile, :as => :resource, :class_name => 'Wave::Profile'
    
  after_save do |user_info|
    if profile = user_info.profile
      profile.touch
    end
  end
  
  def handle
    self[:handle] || first_name
  end
  
  def first_name
    self[:first_name].try(:titleize)
  end
  
  def last_name
    self[:last_name].try(:titleize)
  end
  
  def full_name
    [ first_name, last_name ].compact * ' '
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
