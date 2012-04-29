# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
group1 = Group.create(:name=>"Test Group", :hour_limit=>100, :description=>"Created for testing")
User.create(:user_type=>0, :name=>"Michael", :cas_user=>720656, :initials=>"MT", :email=>"michael.treger@gmail.com", :activated => true)
User.create(:user_type=>0, :name=>"Peter", :cas_user=>760437, :initials=>"PC", :email=>"petercheng00@berkeley.edu", :activated => true)
User.create(:user_type=>0, :name=>"Su Yan Fang", :cas_user =>967198, :initials=>"SYF", :email=>"sohunew4000@gmail.com", :activated => true)
User.create(:user_type=>0, :name=>"Jingwei", :cas_user=> 974333, :initials=>"JQ", :email=>"seven.qi2011@gmail.com", :activated => true)
User.create(:user_type=>0, :name=>"Rohan", :cas_user=> 883140, :initials=>"RC", :email=>"rohan.cribbs@gmail.com", :activated => true)
User.create(:user_type=>0, :name=>"Richard", :cas_user=> 307909, :initials=>"RX", :email=>"richard@richard.richard", :activated => true)
User.create(:user_type=>0, :name=>"Chris", :cas_user=>18453, :initials=>"CW", :email=>"chrisw@cafe.berkeley.edu", :activated => true)
User.create(:user_type=>0, :name=>"Willa", :cas_user=>196233, :initials=>"NC", :email=>"nchan@cafe.berkeley.edu", :activated => true)

User.find(:all).each do |u|
  group1.users << u
end
group1.save!

moffit = Lab.create!(:name=>"Moffit", :initials=>"MMF", :max_employees=>4, :min_employees=>1)
Lab.create!(:name=>"Wheeler", :initials=>"WCF", :max_employees=>3, :min_employees=>1)

Period.create(:start_date=>DateTime.parse("Jan 20, 2012"), :end_date=>DateTime.parse("May 20, 2012"), :name=>"Spring 2012", :visible=>true)

startTime = Time.now
Calendar.find_all_by_calendar_type(Calendar::SHIFTS).each do |c|
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:lab_id=>moffit.id, :entry_type=>:shift, :description=>"MMF", :start_time=>startTime+randStart.hours, :end_time=>startTime+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:lab_id=>moffit.id, :entry_type=>:shift, :description=>"MMF", :start_time=>startTime+1.day+randStart.hours, :end_time=>startTime+1.day+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:lab_id=>moffit.id, :entry_type=>:shift, :description=>"MMF", :start_time=>startTime+2.days+randStart.hours, :end_time=>startTime+2.days+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:lab_id=>moffit.id, :entry_type=>:shift, :description=>"MMF", :start_time=>startTime+3.days+randStart.hours, :end_time=>startTime+3.days+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:lab_id=>moffit.id, :entry_type=>:shift, :description=>"MMF", :start_time=>startTime+4.days+randStart.hours, :end_time=>startTime+4.days+randEnd.hours)
  c.save!
end

Calendar.find_all_by_calendar_type(Calendar::AVAILABILITY).each do |c|
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:entry_type=>:class, :start_time=>startTime+randStart.hours, :end_time=>startTime+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:entry_type=>:rather_not, :start_time=>startTime+1.day+randStart.hours, :end_time=>startTime+1.day+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:entry_type=>:prefer, :start_time=>startTime+2.days+randStart.hours, :end_time=>startTime+2.days+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:entry_type=>:prefer, :start_time=>startTime+3.days+randStart.hours, :end_time=>startTime+3.days+randEnd.hours)
  randStart = rand(20)
  randEnd = randStart + rand(24-randStart)
  c.entries << Entry.create(:entry_type=>:obligation, :description=>"Soccer Practice", :start_time=>startTime+4.days+randStart.hours, :end_time=>startTime+4.days+randEnd.hours)
  c.save!
end


s = Substitution.create(:user_id => 1, :entry_id => 1, :description => "test_sub 1")
s.entry = Entry.find(1)
s.users << User.find(1)
s.save!
