class UserInfo < ActiveRecord::Base

  Gender =
      (a = [ 'Guy', 'Girl', 'Trans', 'All of the above', 'None of the above' ]).zip((1..a.length).to_a)

  Orientation =
      (a = [ 'Gay', 'Lesbian', 'Straight', 'Bisexual', 'Trans', 'Rather not say', 'Not sure', 'Depends' ]).zip((1..a.length).to_a)
			
	Relationship = 
	    (a = [ 'Single', 'In a Relationship', 'Married', 'Yes please!', 'On the rebound', 'Not interested' ]).zip((1..a.length).to_a)
	    
	Deafness =
	    (a = [ 'Deaf', 'Hard of Hearing', 'Hearing' ]).zip((1..a.length).to_a)

  set_table_name 'user_info'

  acts_as_taggable
  
  has_one :profile, :as => :resource, :class_name => 'Wave::Profile'
  
  before_save do |user_info|
    self.tag_list = [
        user_info.gender_description,
        user_info.orientation_description,
        user_info.relationship_description,
        user_info.deafness_description,
        user_info.location_description,
        user_info.dob.try(:strftime, '%B') ].compact * ', '
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
