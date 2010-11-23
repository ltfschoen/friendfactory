namespace :ff do
  namespace :fix do
    desc 'Initialize user_info saves'
    task :tags => :environment do
      UserInfo.all.each { |user_info| user_info.touch && user_info.save! }
    end
  end
end