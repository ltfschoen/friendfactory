namespace :ff do
  namespace :fix do
    task :tags => :environment do
      UserInfo.all.each { |user_info| user_info.touch && user_info.save! }
    end
  end
end