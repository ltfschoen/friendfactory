namespace :ff do
  namespace :db do    
    desc 'Populate the database'
    task :populate => [ :'populate:users', :'populate:waves' ]
  
    namespace :populate do    
      desc 'Populate the database with user data'
      task :users => :environment do
        User.delete_all
        User.create(adam_attrs)
        ids = []
        User.populate(3) do |user|
          user.email      = Faker::Internet.email
          user.first_name = Faker::Name.first_name
          user.last_name  = Faker::Name.last_name      
          ids << user.id
        end
        User.find_all_by_id(ids).each do |user|
          user.password = 'test'
          user.password_confirmation = 'test'
          user.save
        end
      end
  
      desc 'Populate the database with some data'
      task :waves => :environment do
        adam  = User.find_by_email(adam_attrs[:email])
        users = User.all - adam
        if adam && !users.empty?        
          Message.delete_all
        
          # Adam's received messages
          create_message(users[rand(users.length)], adam)
          create_thread(users[rand(users.length)], adam, :length => 3)
          create_thread(users[rand(users.length)], adam, :length => 5)
        
          # create_message(adam, users[rand(users.length)])
          # create_thread(adam, users[rand(users.length)], :length => 2)
          # create_thread(adam, users[rand(users.length)], :length => 3)
          # create_thread(users[rand(users.length)], adam, :length => 2)
          # create_thread(users[rand(users.length)], adam, :length => 3)
        end
      end
    end
  end
end

def adam_attrs
  returning Hash.new do |attrs|
    attrs[:email]      = 'adam@test.com'
    attrs[:first_name] = 'Adam'
    attrs[:last_name]  = 'Ant'
    attrs[:password]   = 'test'
    attrs[:password_confirmation] = 'test'
  end
end

def create_message(sender, receiver, created_at = Time.now)
  Message.record_timestamps = false
  message = sender.send_message(
      :receiver => receiver,
      :body     => (Faker::Lorem.sentences * ' '))
  message[:created_at] = created_at
  message.save
  Message.record_timestamps = true
  message
end

def create_thread(sender, receiver, opts = {})
  length = opts[:length].to_i
  if length > 0
    start_date = Time.now - length.days
    message = create_message(sender, receiver, start_date)
    Message.record_timestamps = false
    2.upto(length) do |count|
      message = message.reply(:body => (Faker::Lorem.sentences * ' '))
      message[:created_at] = start_date + count.days 
      message.save
    end
    Message.record_timestamps = true
  end
end
