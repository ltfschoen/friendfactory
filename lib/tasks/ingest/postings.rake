namespace :ff do
  namespace :ingest do
    desc "Ingest postings to redis"
    task :postings => [ :environment ] do
      Posting::Base.includes(:publishables).find_each do |posting|
        posting.send :ingest if posting.respond_to? :ingest
        publications = posting.publishables
        publications.each do |publication|
          wave = publication.wave
          wave.add_posting posting if wave.respond_to? :add_posting
        end
      end
    end
  end
end
