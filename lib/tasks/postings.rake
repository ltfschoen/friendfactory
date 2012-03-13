namespace :ff do
  namespace :postings do
    desc "Unstick expired sticky postings"
    task :unstick => :environment do
      Posting::Base.update_all([ '`postings`.`sticky_until` = ?', nil ], [ '`postings`.`sticky_until` < ?', Time.now.utc ])
    end
  end
end