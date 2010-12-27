FactoryGirl.define do
  factory :duncan, :class => User do |user|
    user.first_name             'duncan'
    user.email                  'duncan@test.com'
    user.password               'test'
    user.password_confirmation  'test'
  end
  
  factory :ernie, :class => User do |user|
    user.first_name             'ernie'
    user.email                  'ernie@test.com'
    user.password               'test'
    user.password_confirmation  'test'    
  end
end
