namespace :ff do
  namespace :mailer do
    task :friendships => :environment do
      Friendship::Poke.since(100.days.ago).group_by { |poke| poke.friend }.each do |recipient, pokes|
        # FriendshipsMailer.delay.create(recipient, pokes, current_site, request.host, request.port)
      end
    end
  end
end
