namespace :ff do
  namespace :count_caches do
    task :recalculate => :environment do
      ActiveRecord::Base.transaction do
        Wave::Base.find_each do |wave|
          publication_count = wave.publications.published.count
          wave.class.update_all({ :publications_count => publication_count }, { :id => wave[:id] })
        end

        Posting::Base.find_each do |posting|
          children_count = posting.children.count
          posting.class.update_all({ :children_count => children_count }, { :id => posting[:id] })
        end
      end
    end
  end
end
