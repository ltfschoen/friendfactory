namespace :ff do
  namespace :fix do
    task :person_locations => :environment do
      ActiveRecord::Base.record_timestamps = false
      offset = ENV['OFFSET'] || 0
      limit = ENV['LIMIT'] || 1000
      Persona::Person.offset(offset).limit(limit).all.each do |person|
        loc = person.location; person.location = loc
        person.save(:validate => false)
      end
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
