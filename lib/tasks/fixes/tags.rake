namespace :ff do
  namespace :fix do
    
    task :admin_tags => :environment do
      
      states =
        [['Alabama,USA', 'AL'], ['Alaska,USA', 'AK'], ['American Samoa', 'AS'], ['Arizona,USA', 'AZ'], ['Arkansas,USA', 'AR'],
        ['California,USA', 'CA'], ['Colorado,USA', 'CO'], ['Connecticut,USA', 'CT'], ['Delaware,USA', 'DE'], ['Washington DC,USA', 'DC'],
        ['Florida,USA', 'FL'], ['Georgia,USA', 'GA'], ['Guam', 'GU'], ['Hawaii,USA', 'HI'],
        ['Idaho,USA', 'ID'], ['Illinois,USA', 'IL'], ['Indiana,USA', 'IN'], ['Iowa,USA', 'IA'],
        ['Kansas,USA', 'KS'], ['Kentucky,USA', 'KY'], ['Louisiana,USA', 'LA'], ['Maine,USA', 'ME'],
        ['Maryland,USA', 'MD'], ['Massachusetts,USA', 'MA'], ['Michigan,USA', 'MI'], ['Minnesota,USA', 'MN'],
        ['Mississippi,USA', 'MS'], ['Missouri,USA', 'MO'], ['Montana,USA', 'MT'], ['Nebraska,USA', 'NE'],
        ['Nevada,USA', 'NV'], ['New Hampshire,USA', 'NH'], ['New Jersey,USA', 'NJ'],
        ['New Mexico,USA', 'NM'], ['New York,USA', 'NY'], ['North Carolina,USA', 'NC'], ['North Dakota,USA', 'ND'],
        ['Ohio,USA', 'OH'], ['Oklahoma,USA', 'OK'], ['Oregon,USA', 'OR'],
        ['Pennsylvania,USA', 'PA'], ['Puerto Rico', 'PR'], ['Rhode Island,USA', 'RI'],
        ['South Carolina,USA', 'SC'], ['South Dakota,USA', 'SD'],
        ['Tennessee,USA', 'TN'], ['Texas,USA', 'TX'], ['Utah,USA', 'UT'],
        ['Vermont,USA', 'VT'], ['Virgin Islands', 'VI'],
        ['Virginia,USA', 'VA'], ['Washington,USA', 'WA'],
        ['West Virginia,USA', 'WV'], ['Wisconsin,USA', 'WI'],
        ['Wyoming,USA', 'WY']]
      
      # Admin::Tag.delete_all(:corrected => '') 
      # Admin::Tag.delete_all(:corrected => nil)
      Admin::Tag.delete_all
        
      # Admin::Tag.where('corrected is not null').each do |tag|
      #   tag.defective = '\b' + tag.defective.strip + '\b'
      #   tag.corrected = case tag.corrected
      #     when 'usa' then 'USA'
      #     when 'washington dc' then 'Washington DC'
      #     else tag.corrected.titleize
      #   end
      #   tag.save!
      # end

      ActsAsTaggableOn::Tag.delete_all
      ActsAsTaggableOn::Tagging.delete_all

      states.each do |state|
        Admin::Tag.create!(:taggable_type => 'UserInfo', :defective => "\\b#{state[1]}$", :corrected => state[0])
      end
    end
    
  end
end
