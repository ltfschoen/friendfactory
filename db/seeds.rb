# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Wave::Community.find_or_create_by_site_id_and_slug(
    :site_id     => FriskyhandsSite.new.id,
    :slug        => Wave::CommunitiesController::DefaultWaveSlug,
    :topic       => 'FriskyHands Wave',
    :description => '')

Wave::Community.find_or_create_by_site_id_and_slug(
    :site_id     => PositivelyfriskySite.new.id,
    :slug        => Wave::CommunitiesController::DefaultWaveSlug,
    :topic       => 'PositivelyFrisky Wave',
    :description => '')

Wave::Community.find_or_create_by_site_id_and_slug(
    :site_id     => FriskysoldiersSite.new.id,
    :slug        => Wave::CommunitiesController::DefaultWaveSlug,
    :topic       => 'FriskySoldiers Wave',
    :description => '')
