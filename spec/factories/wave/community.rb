FactoryGirl.define do
  factory :wave_community, class: Wave::Community do
    slug Site::DefaultHomeWaveSlug
  end
end
