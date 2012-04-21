namespace :db do
  desc "This loads the development data."
  task :seed => :environment do
    #User.create( :user_type => 'default', :name => 'Michael', :email=> "michael.treger@gmail.com", :cas_user=> 720560 )
    #User.create( :user_type => 'admin', :name => 'Chris', :email=> "chis@gmail.com", :cas_user=> 55555 )
    
    year = 2012
    month = 4
    day = 3
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day, 10), :end_time=> DateTime.new(year, month, day, 13), :entry_type=>"prefer", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day, 14), :end_time=> DateTime.new(year, month, day, 16), :entry_type=>"class", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day+1, 17), :end_time=> DateTime.new(year, month, day+1, 19), :entry_type=>"class", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day-1, 8), :end_time=> DateTime.new(year, month, day-1, 14), :entry_type=>"obligation", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day+2, 18), :end_time=> DateTime.new(year, month, day+3, 2), :entry_type=>"rather_not", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day+3, 8), :end_time=> DateTime.new(year, month, day+4, 2), :entry_type=>"closed", :user_id=>1)

    #Calendar.create(:calendar_type=>1, :name=>"test")
  end
end
