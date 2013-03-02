FactoryGirl.define do
  factory :site, aliases: [ :friskysite ] do
    name 'Frisky Site'
    launch false
    invite_only false
  end
end

FactoryGirl.define do
  factory :invite_site, parent: :site do
    name 'Frisky Invite Site'
    invite_only true
  end
end
