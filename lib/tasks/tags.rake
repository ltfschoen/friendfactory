namespace :ff do
  namespace :tags do
    desc 'Scrub user_info tags'
    task :refresh => :environment do
      UserInfo.all.each { |user_info| user_info.touch && user_info.save! }
      ActsAsTaggableOn::Tag.all.select{ |t| t.taggings.empty? }.each{ |t| t.delete }
    end
  end
end