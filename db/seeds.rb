# =============
# Template Site

# def site
#   @site ||= Site.template
# rescue
#   Site.create!(
#     :name => Site::TemplateSiteName,
#     :display_name => 'FriskyFactory',
#     :analytics_account_number => '',
#     :analytics_domain_name => '')
# end


# =======
# CSS

# file = File.join(Rails.root, 'db', 'seeds', "#{site.name}.css")
# if File.exists?(file)
#   site.stylesheets.clear
#   site.stylesheets.create(:css => IO.read(file))
# end


# ==========
# Biometrics

def create_biometric_value(*names)
  names.inject([]) do |memo, name|
    name, display_name = name.is_a?(Array) ? [ name.first, name.last ] : [ name, name.titleize ]
    unless value = Biometric::Value.find_by_name(name)
      value = Biometric::Value.create!(:name => name, :display_name => display_name)
    end
    memo << value
  end
end

## Gender
create_biometric_value(
  [ 'gender_male', 'Male' ],
  [ 'gender_female', 'Female' ],
  [ 'gender_transexual', 'Trans' ],
  [ 'gender_not_say', 'Rather Not Say' ])

## Orientation
create_biometric_value(
  [ 'orientation_gay', 'Gay' ],
  [ 'orientation_lesbian', 'Lesbian' ],
  [ 'orientation_straight', 'Straight' ],
  [ 'orientation_bisexual', 'Bisexual' ],
  [ 'orientation_transexual', 'Trans' ],
  [ 'orientation_queer', 'Queer' ],
  [ 'orientation_questioning', 'Questioning' ],
  [ 'orientation_not_say', 'Rather Not Say' ])

## Sex Postiion
create_biometric_value(
  [ 'sex_position_top', 'Top' ],
  [ 'sex_position_bottom', 'Bottom' ],
  [ 'sex_position_versatile', 'Versatile' ],
  [ 'sex_position_other', 'Other' ],
  [ 'sex_position_not_say', 'Rather Not Say' ],
  [ 'sex_position_ask_me', 'Ask Me' ])

## Relationship
create_biometric_value(
  [ 'relationship_single', 'Single' ],
  [ 'relationship_in_relationship', 'In a Relationship' ],
  [ 'relationship_partnered', 'Partnered' ],
  [ 'relationship_dating', 'Dating' ],
  [ 'relationship_married', 'Married' ],
  [ 'relationship_looking_for_relationship' , 'Looking' ],
  [ 'relationship_friends_only', 'Friends Only' ],
  [ 'relationship_exclusive', 'Exclusive' ],
  [ 'relationship_committed', 'Committed' ],
  [ 'relationship_open', 'Open' ],
  [ 'relationship_widowed', 'Widowed' ],
  [ 'relationship_complicated', "It's complicated" ],
  [ 'relationship_not_say', 'Rather Not Say' ])

## Deafness
create_biometric_value(
  [ 'deafness_deaf', 'Deaf' ],
  [ 'deafness_hard_of_hearing', 'Hard of Hearing' ],
  [ 'deafness_hearing', 'Hearing' ],
  [ 'deafness_coda', 'CODA' ],
  [ 'deafness_not_say', 'Rather Not Say' ])

## HIV Status
create_biometric_value(
  [ 'hiv_status_positive', 'Positive' ],
  [ 'hiv_status_negative', 'Negative' ],
  [ 'hiv_status_dont_know', "Don't know" ],
  [ 'hiv_status_testing', 'Testing' ],
  [ 'hiv_status_not_say', 'Rather Not Say' ])

## Board Type
create_biometric_value(
  [ 'board_type_surf', 'Surf' ],
  [ 'board_type_snow', 'Snow' ],
  [ 'board_type_skate', 'Skate' ])

## Military Service
create_biometric_value(
  [ 'military_service_navy', 'Seaman' ],
  [ 'military_service_airforce', 'Flyier' ],
  [ 'military_service_army', 'Soldier' ],
  [ 'military_service_marine', 'Marine' ],
  [ 'military_service_seal', 'SEAL' ],
  [ 'military_service_guard', 'Guard' ],
  [ 'military_service_reserve', 'Reserve' ])

## Smoker
create_biometric_value(
  [ 'smoke_smoker', 'Smoker' ],
  [ 'smoke_nonsmoker', 'Nonsmoker' ],
  [ 'smoke_ecigarette', 'Cigarette Only' ])

## Body Type
create_biometric_value(
  [ 'body_type_slim', 'Slim' ],
  [ 'body_type_average', 'Average' ],
  [ 'body_type_swimmer', 'Swimmer' ],
  [ 'body_type_muscle', 'muscle' ],
  [ 'body_type_bulk', 'Bulk' ],
  [ 'body_type_extra_pounds', 'Few extra pounds' ],
  [ 'body_type_big_beautiful', 'Big and beautiful' ])

## Appearance
create_biometric_value(
  [ 'appearance_average', 'Average' ],
  [ 'appearance_good', 'Good' ],
  [ 'appearance_very_good', 'Very good' ],
  [ 'appearance_stunning', 'Stunning' ])

## Scene
create_biometric_value(
  [ 'scene_casual', 'Casual' ],
  [ 'scene_leather', 'Leather' ],
  [ 'scene_drag', 'Drag' ],
  [ 'scene_military', 'Military' ],
  [ 'scene_conservative', 'Conservative' ],
  [ 'scene_alternative', 'Alternative' ],
  [ 'scene_jock', 'Jock' ],
  [ 'scene_muscle', 'Muscle' ],
  [ 'scene_trendy', 'Trendy' ],
  [ 'scene_punk', 'Punk' ],
  [ 'scene_goth', 'Goth' ],
  [ 'scene_emo', 'EMO' ],
  [ 'scene_lipstick', 'Lipstick' ],
  [ 'scene_butch', 'Butch' ],
  [ 'scene_femme', 'Femme' ])

## Substance
create_biometric_value(
  [ 'substance_pills', 'Pills' ],
  [ 'substance_booze', 'Booze' ],
  [ 'substance_powders', 'Powders' ],
  [ 'substance_needles', 'Needles' ],
  [ 'substance_sex', 'Sex' ])

## Substance Recovery
create_biometric_value(
  [ 'substance_recovery_in_recovery', 'In Recovery' ],
  [ 'substance_recovery_not_trying', 'Not Trying' ],
  [ 'substance_recovery_dry', 'Dry' ],
  [ 'substance_recovery_high', 'High' ])

## Substance Treatment
create_biometric_value(
  [ 'substance_treatment_12_step', '12-Step' ],
  [ 'substance_treatment_counseling', 'Counseling' ],
  [ 'substance_treatment_medical', 'Medical' ],
  [ 'substance_treatment_detox', 'Detox' ],
  [ 'substance_treatment_28_day', '28-Day' ])

## Deaf Sign Language
create_biometric_value(
  [ 'deaf_sign_australian', 'Australian' ],
  [ 'deaf_sign_british', 'British' ],
  [ 'deaf_sign_american', 'American' ],
  [ 'deaf_sign_canadian', 'Canadian' ],
  [ 'deaf_sign_international', 'International' ])

## Ethnicity
create_biometric_value(
  [ 'ethnicity_white', 'White' ],
  [ 'ethnicity_asian', 'Asian' ],
  [ 'ethnicity_black', 'Black' ],
  [ 'ethnicity_latino', 'Latino' ],
  [ 'ethnicity_middle_eastern', 'Middle Eastern' ],
  [ 'ethnicity_mixed', 'Mixed' ],
  [ 'ethnicity_not_say', 'Rather Not Say' ])

## 2nd Language
create_biometric_value(
  [ '2nd_language_english', 'English' ],
  [ '2nd_language_spanish', 'Spanish' ],
  [ '2nd_language_mandarin', 'Mandarin' ],
  [ '2nd_language_hindi', 'Hindi' ],
  [ '2nd_language_russian', 'Russian' ],
  [ '2nd_language_french', 'French' ],
  [ '2nd_language_portuguese', 'Portuguese' ],
  [ '2nd_language_italian', 'Italian' ],
  [ '2nd_language_other', 'Other' ])

## Hair Color
create_biometric_value(
  [ 'hair_color_blond', 'Blond' ],
  [ 'hair_color_black', 'Black' ],
  [ 'hair_color_brown', 'Brown' ],
  [ 'hair_color_red', 'Red' ],
  [ 'hair_color_gray', 'Gray' ],
  [ 'hair_color_white', 'White' ],
  [ 'hair_color_shaved', 'Shaved' ],
  [ 'hair_color_bald', 'Bald' ],
  [ 'hair_color_other', 'Other' ])

## Cruise
create_biometric_value(
  [ 'cruise_mediterranean', 'Mediterranean' ],
  [ 'cruise_baltic', 'Baltic' ],
  [ 'cruise_caribbean', 'Caribbean' ],
  [ 'cruise_mexico', 'Mexico' ],
  [ 'cruise_asia', 'Asia' ],
  [ 'cruise_hawaii', 'Hawaii' ],
  [ 'cruise_alaska', 'Alaska' ],
  [ 'cruise_other', 'Other' ])
  
## Injury
create_biometric_value(
  [ 'injury_spinal', 'Spinal' ],
  [ 'injury_paralysis', 'Paralysis' ],
  [ 'injury_military', 'Military' ],
  [ 'injury_accidental', 'Accidental' ],
  [ 'injury_other', 'Other' ],
  [ 'injury_not_say', 'Rather Not Say' ])

## Accommodation
create_biometric_value(
  [ 'accommodation_cabin_outside', 'Cabin - Outside' ],
  [ 'accommodation_cabin_inside', 'Cabin - Inside' ],
  [ 'accommodation_stateroom', 'Stateroom' ],
  [ 'accommodation_balcony', 'Balcony' ],
  [ 'accommodation_no_balcony', 'No Balcony' ])
