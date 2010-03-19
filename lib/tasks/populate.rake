desc 'Populate the database'
task :populate => 'populate:all'

namespace :populate do  
  task :all => [ :clean, :adam, :users, :messages ]

  task :clean => :environment do
    User.delete_all
    Message.delete_all
  end
  
  task :adam => :environment do
    User.create(adam_attrs)
  end
  
  desc 'Populate the database with user data'
  task :users => :environment do
    ids = []
    User.populate(100) do |user|
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
  task :messages => :environment do
    users = User.all
    adam  = User.find_by_email(adam_attrs[:email])
    if adam
      Message.populate(50) do |message|
        message.sender_id   = adam.id
        message.receiver_id = users[rand(users.length)].id
        message.subject     = Faker::Company.catch_phrase
        message.body        = Faker::Lorem.sentences * ' '
      end
      Message.populate(50) do |message|
        message.sender_id   = users[rand(users.length)].id
        message.receiver_id = adam.id
        message.subject     = Faker::Company.catch_phrase
        message.body        = Faker::Lorem.sentences * ' '
        message.created_at  = 
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
