namespace :ff do
  namespace :count_cache do
    
    desc 'Recalculate postings and comments counts'
    task :recalculate => [ :'recalculate:postings', :'recalculate:comments']

    namespace :recalculate do
      desc 'Recalculate published postings count for waves'
      task :postings => :environment do
        ActiveRecord::Base.transaction do
          Wave::Base.find_each do |wave|
            publications_count = wave.publications.published.count
            wave.class.update_all({ :publications_count => publications_count }, { :id => wave[:id] })
          end
        end
      end

      desc 'Recalculate 2-level comments count for postings'
      task :comments => :environment do
        ActiveRecord::Base.transaction do
          Posting::Base.find_each do |posting|
            comments_count = posting.comments.count
            posting.class.update_all({ :comments_count => comments_count }, { :id => posting[:id] })
          end
        end
      end
    end

  end
end
