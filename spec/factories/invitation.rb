FactoryGirl.define do
  factory :invitation do
    code 666
    association :site, :factory => :invite_site
    association :sponsor, :factory => :charlie
  end
end
