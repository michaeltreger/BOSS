# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(:user_type=>0, :name=>"Michael", :cas_user=>720656, :initials=>"MT", :email=>"michael.treger@gmail.com")
User.create(:user_type=>0, :name=>"Peter", :cas_user=>760437, :initials=>"PC")
User.create(:user_type=>0, :name=>"Su Yan Fang", :cas_user =>967198, :initials=>"SYF")
User.create(:user_type=>0, :name=>"Jingwei", :cas_user=> 974333, :initials=>"JQ", :email=>"seven.qi2011@gmail.com")
User.create(:user_type=>0, :name=>"Rohan", :cas_user=> 883140, :initials=>"RC")
User.create(:user_type=>0, :name=>"Richard", :cas_user=> 307909, :initials=>"RX")

Lab.create!(:name=>"Moffit", :initials=>"MMF", :max_employees=>4, :min_employees=>1)
Lab.create!(:name=>"Wheeler", :initials=>"WCF", :max_employees=>3, :min_employees=>1)

Period.create(:start_date=>DateTime.parse("Jan 20, 2012"), :end_date=>DateTime.parse("May 20, 2012"), :name=>"Spring 2012", :visible=>true)
Period.find(1).create_calendars
Period.find(1).save!

monday = Time.now.beginning_of_week
Calendar.find_all_by_calendar_type(Calendar::SHIFTS).each do |c|
  c.entries << Entry.create(:entry_type=>:shift, :description=>"MMF", :start_time=>monday+10.hours, :end_time=>monday+15.hours)
  c.entries << Entry.create(:entry_type=>:shift, :description=>"MMF", :start_time=>monday+1.day+10.hours, :end_time=>monday+1.day+15.hours)
  c.entries << Entry.create(:entry_type=>:shift, :description=>"MMF", :start_time=>monday+2.days+14.hours, :end_time=>monday+2.days+20.hours)
  c.entries << Entry.create(:entry_type=>:shift, :description=>"MMF", :start_time=>monday+3.days+9.hours, :end_time=>monday+3.days+15.hours)
  c.entries << Entry.create(:entry_type=>:shift, :description=>"MMF", :start_time=>monday+4.days+17.hours, :end_time=>monday+4.days+22.hours)
  c.save!
end
