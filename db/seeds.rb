# =============
# Template Site

site = Site.find_or_create_by_name(
    :name => 'friskyfactory',
    :display_name => 'FriskyFactory',
    :analytics_account_number => '',
    :analytics_domain_name => '')


# =======
# Signals

def ordinal
  Time.now.strftime('%H%M')
end

def create_signal(*names)
  names.inject([]) do |memo, name|
    name, display_name = name.is_a?(Array) ? [ name.first, name.last ] : [ name, name.titleize ]
    unless (signal = Signal::Base.find_by_name(name)).present?
      signal = Signal::SingleValue.create(:name => name, :display_name => display_name)
    end
    memo << signal
  end
end


def create_signal_category(site, name, display_name, subject_type, *signals)
  if category = site.signal_categories.where(:name => name).first
    category.signals.clear
  else
    category = site.signal_categories.create(:name => name, :display_name => display_name, :subject_type => subject_type)    
  end
  category.signals << signals
end


## Gender
signals = create_signal(
    [ 'gender_male', 'Male' ],
    [ 'gender_female', 'Female' ],
    [ 'gender_trans', 'Trans' ])

create_signal_category(site, 'gender', 'Gender', Wave::Profile, signals)

## Orientation
signals = create_signal(
    [ 'orientation_gay', 'Gay' ],
    [ 'orientation_straight', 'Straight' ],
    [ 'orientation_bisexual', 'Bisexual' ],
    [ 'gender_trans', 'Trans' ])

create_signal_category(site, 'orientation', 'Orientation', Wave::Profile, signals)

## Relationship
signals = create_signal(
    [ 'relationship_single', 'Single' ],
    [ 'relationship_in_relationship', 'In a Relationship' ],
    [ 'relationship_married', 'Married' ],
    [ 'relationship_looking_for_relationship' , 'Looking for a Relationship' ],
    [ 'relationship_friends_only', 'Friends Only' ])

create_signal_category(site, 'relationship', 'Relationship', Wave::Profile, signals)

## Deafness
signals = create_signal(
    [ 'deafness_deaf', 'Deaf' ],
    [ 'deafness_hard_of_hearing', 'Hard of Hearing'],
    [ 'deafness_hearing', 'Hearing' ],
    [ 'deafness_coda', 'CODA' ])

create_signal_category(site, 'deafness', 'Deafness', Wave::Profile, signals)

## HIV Status
signals = create_signal(
    [ 'hiv_status_positive', 'Positive' ],
    [ 'hiv_status_negative', 'Negative' ],
    [ 'hiv_status_dont_know', "Don't know" ])

create_signal_category(site, 'hiv_status', 'HIV Status', Wave::Profile, signals)

## Board Type
signals = create_signal(
    [ 'board_type_surf', 'Surf' ],
    [ 'board_type_snow', 'Snow' ],
    [ 'board_type_skate', 'Skate' ])

create_signal_category(site, 'board_type', 'Board', Wave::Profile, signals)

## Military Service
signals = create_signal(
    [ 'military_service_navy', 'Seaman' ],
    [ 'military_service_airforce', 'Flyier' ],
    [ 'military_service_army', 'Soldier' ],
    [ 'military_service_marine', 'Marine' ],
    [ 'military_service_guard', 'Guard' ],
    [ 'military_service_reserve', 'Reserve' ])

create_signal_category(site, 'military_service', 'Service', Wave::Profile, signals)
