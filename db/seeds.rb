# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Wave::Hottie.find_or_create_by_slug(:slug => 'shared',  :topic => "Everyone's Wall", :description => 'Get going!')
Wave::Hottie.find_or_create_by_slug(:slug => 'hotties', :topic => 'Hotties', :description => 'The Hottest Guys on FriskyHands')
