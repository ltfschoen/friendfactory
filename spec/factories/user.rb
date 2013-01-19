FactoryGirl.define do
  factory :user, aliases: [ :adam ] do
    handle "adam"
    email "adam@test.com"
    password "test"
    password_confirmation "test"
    association :site
    # current_site build :site
    # invitations { |invitations| [ invitations.association(:invitation) ]}
  end

  factory :bert, class: User do
    handle 'bert'
    email 'bert@test.com'
    password 'test'
    current_site FactoryGirl.build :site
    password_confirmation 'test'
  end

  factory :charlie, class: User do
    handle 'charlie'
    email 'charlie@test.com'
    password 'test'
    password_confirmation 'test'
    current_site FactoryGirl.build :site
    admin true
  end
end



