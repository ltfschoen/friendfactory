class UserInfo < ActiveRecord::Base

  Gender =
      (a = [ 'Guy', 'Girl', 'Trans' ]).zip((1..a.length).to_a)

  Orientation =
      (a = [ 'Gay', 'Lesbian', 'Straight', 'Bisexual', 'Trans' ]).zip((1..a.length).to_a)
			
	Relationship = 
	    (a = [ 'Single', 'In a Relationship', 'Married', 'Looking for a Relationship', 'On the Rebound', 'Friends Only' ]).zip((1..a.length).to_a)
	    
	Deafness =
	    (a = [ 'Deaf', 'Hard of Hearing', 'Hearing', 'CODA' ]).zip((1..a.length).to_a)

  set_table_name 'user_info'

  acts_as_taggable
  
  has_one :profile, :as => :resource, :class_name => 'Wave::Profile'
  
  before_save do |user_info|
    self.tag_list = [
        user_info.gender_description.try(:downcase),
        user_info.orientation_description.try(:downcase),
        user_info.relationship_description.try(:downcase),
        user_info.deafness_description.try(:downcase),
        UserInfo.scrub_tag(user_info.location_description) ].compact * ', '
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

  Rejects = [ 'USA', 'US', 'UK', 'AUSTRALIA', 'CANADA',
      'AL', 'AK', 'AS', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE',
      'DC', 'FM', 'FL', 'GA', 'GU', 'HI', 'ID', 'IL', 'IN', 'IA',
      'KS', 'KY', 'LA', 'ME', 'MH', 'MD', 'MA', 'MI', 'MN', 'MS',
      'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND',
      'MP', 'OH', 'OK', 'OR', 'PW', 'PA', 'PR', 'RI', 'SC', 'SD',
      'TN', 'TX', 'UT', 'VT', 'VI', 'VA', 'WA', 'WV', 'WI', 'WY' ]
  
  Transposes = {
      'nyc' => 'New York City',
      'la'  => 'Los Angeles',
      'sf'  => 'San Francisco' }
  
  def self.scrub_tag(tag)
    unless tag.nil?
      tag = tag.gsub(/,/, ' ').gsub(/'|"|\.|-/, '').gsub(/\b(#{UserInfo::Rejects * '|'})\b/i, '').gsub(/\s{2,}/, ' ')
      UserInfo::Transposes.each do |transpose|
        tag = tag.gsub(/\b#{transpose[0]}\b/i, transpose[1])
      end
      tag.nil? || (tag.length > 16) ? nil : tag.downcase
    end
  end
  
end
