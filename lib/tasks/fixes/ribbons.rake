namespace :ff do
  namespace :fix do
    task :ribbons => :environment do
      ActiveRecord::Base.record_timestamps = false
      
      ActiveRecord::Base.record_timestamps = true
    end
  end
end
