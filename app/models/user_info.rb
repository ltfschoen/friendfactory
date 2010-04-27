class UserInfo < ActiveRecord::Base

  Gender =
      (a = [ 'Guy', 'Girl', 'All of the above' ]).zip((1..a.length).to_a)

  Orientation =
      (a = [ 'Gay', 'Lesbian', 'Straight', 'Bisexual', 'Trans', 'Rather not say', 'Not sure', 'Depends...' ]).zip((1..a.length).to_a)
			
	Relationship = 
	    (a = [ 'Single', 'In a Relationship', 'Married', 'Yes, please!', 'No, thanks' ]).zip((1..a.length).to_a)
	    
	Deafness =
	    (a = [ 'Deaf', 'Hard of Hearing', 'Hearing']).zip((1..a.length).to_a)

  set_table_name 'user_info'

  belongs_to :user
      
end
