namespace :ff do
  namespace :fix do
    task :person_locations => :environment do
      ActiveRecord::Base.record_timestamps = false
      offset = ENV['OFFSET'].to_i || 0
      limit = ENV['LIMIT'].to_i || 1000
      ActiveRecord::Base.transaction do
        Persona::Person.offset(offset).limit(limit).all.each do |person|
          loc = person.location; person.location = loc
          person.save(:validate => false)
        end
      end
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
