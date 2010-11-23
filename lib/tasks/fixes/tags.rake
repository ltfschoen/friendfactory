namespace :ff do
  namespace :fix do
    desc 'Initialize user_info saves'
    task :tags => :environment do
      ActsAsTaggableOn::Tag.delete_all
      ActsAsTaggableOn::Tagging.delete_all
      UserInfo.all.each { |user_info| user_info.touch && user_info.save! }
    end
  end
end