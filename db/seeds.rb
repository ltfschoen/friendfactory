# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Wave::Community.find_or_create_by_slug(
    :slug        => Wave::CommunitiesController::DefaultWaveSlug,
    :topic       => "Everyone's Wall",
    :description => 'Get going!')


[ [ 'nyc', 'new york' ],
  [ 'la', 'los angeles' ],
  [ 'sf', 'san francisco' ],
  ['usa'], ['us'],
  ['uk'],
  ['australia'],
  ['canada'],
  ['al'], ['ak'], ['as'], ['az'], ['ar'], ['ca'], ['co'], ['ct'], ['de'],
  ['dc'], ['fm'], ['fl'], ['ga'], ['gu'], ['hi'], ['id'], ['il'], ['in'], ['ia'],
  ['ks'], ['ky'], ['la'], ['me'], ['mh'], ['md'], ['ma'], ['mi'], ['mn'], ['ms'],
  ['mo'], ['mt'], ['ne'], ['nv'], ['nh'], ['nj'], ['nm'], ['ny'], ['nc'], ['nd'],
  ['mp'], ['oh'], ['ok'], ['or'], ['pw'], ['pa'], ['pr'], ['ri'], ['sc'], ['sd'],
  ['tn'], ['tx'], ['ut'], ['vt'], ['vi'], ['va'], ['wa'], ['wv'], ['wi'], ['wy'] ].each do |transpose|
  Admin::Tag.find_or_create_by_defective(:defective => transpose[0], :corrected => transpose[1]) do |tag|
    tag.taggable_type = 'UserInfo'
  end
end

