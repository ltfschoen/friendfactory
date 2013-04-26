namespace :ff do
  namespace :metadata do
    desc "Load metadata"
    task :load => [ :environment ] do
      Posting::Base.find_each do |posting|
        posting.send :ingest if posting.respond_to? :ingest
      end
    end
  end
end
