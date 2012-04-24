namespace :ff do
  namespace :count_caches do
    task :recalculate => :environment do
      ActiveRecord::Base.transaction do
        Wave::Base.find_each do |wave|
          publications_count = wave.publications.published.count
          wave.class.update_all({ :publications_count => publications_count }, { :id => wave[:id] })
        end

        Posting::Base.find_each do |posting|
          comments_count = posting.comments.count
          posting.class.update_all({ :comments_count => comments_count }, { :id => posting[:id] })
        end
      end
    end
  end
end
