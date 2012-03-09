namespace :ff do
  namespace :fix do
    task :person_locations => :environment do
      ActiveRecord::Base.record_timestamps = false
      limit = ENV['LIMIT'].to_i || 2000
      ActiveRecord::Base.transaction do
        Persona::Person.where('(lat is null) or (lng is null)').order('`id` ASC').limit(limit).all.each do |person|
          loc = person.location; person.location = loc
          person.save(:validate => false)
        end
      end
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
