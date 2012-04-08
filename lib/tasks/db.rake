namespace :db do
  desc "This loads the development data."
  task :seed => :environment do
    User.create( :user_type => 'default', :name => 'Michael', :email=> "michael.treger@gmail.com", :cas_user=> 720560 )
    User.create( :user_type => 'admin', :name => 'Chris', :email=> "chis@gmail.com", :cas_user=> 55555 )
    
    year = 2012
    month = 4
    day = 3
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day, 10), :end_time=> DateTime.new(year, month, day, 13), :description=>"prefer", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day, 14), :end_time=> DateTime.new(year, month, day, 16), :description=>"class", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day+1, 17), :end_time=> DateTime.new(year, month, day+1, 19), :description=>"class", :user_id=>1)
    Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day-1, 8), :end_time=> DateTime.new(year, month, day-1, 14), :description=>"obligation", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day+2, 18), :end_time=> DateTime.new(year, month, day+3, 2), :description=>"rather_not", :user_id=>1)
    #Entry.create(:calendar_id=>1,:start_time=> DateTime.new(year, month, day+3, 8), :end_time=> DateTime.new(year, month, day+4, 2), :description=>"closed", :user_id=>1)

    Calendar.create(:calendar_type=>1, :name=>"test")
  end
end
