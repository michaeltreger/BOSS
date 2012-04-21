# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(:user_type=>0, :name=>"Michael", :cas_user=>720656, :initials=>"MT", :email=>"michael.treger@gmail.com")
User.create(:user_type=>0, :name=>"Peter", :cas_user=>760437, :initials=>"PC")
User.create(:user_type=>1, :name=>"Su Yan Fang", :cas_user =>967198)


Period.create(:start_date=>DateTime.parse("Jan 20, 2012"), :end_date=>DateTime.parse("May 20, 2012"), :name=>"Spring 2012")
Period.find(1).create_calendars
Period.find(1).save!
