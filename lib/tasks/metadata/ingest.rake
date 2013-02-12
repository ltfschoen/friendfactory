namespace :ff do
  namespace :metadata do
    desc "Ingest postings metadata"
    task :ingest => [ :environment ] do
      Posting::Base.find_each do |posting|
        posting.send :ingest if posting.respond_to? :ingest
      end
    end
  end
end
