require 'spec_helper'
include ActionView::Helpers::DateHelper

describe TimeOffRequest do
   before(:each) do
    Period.create(:start_date=>Time.now-2.months, :end_date=>Time.now+2.months, :name=>"Period", :visible=>true)
    @me = User.create!(:name => 'Seven', :activated => 'true', :initials => 'S')
    @my_calendar = Calendar.create!(:calendar_type => 1, :name => 'my_calendar', :user_id => @me.id)
    @my_entry = Entry.create!(:user_id => @me.id, :calendar_id => @my_calendar.id, :start_time => '10:00am', :end_time => '11:00am')
  end
  it "should calculate distance of time" do
    time_off_request = TimeOffRequest.create!(:user_id => @me.id, :start_time => Time.current(), :end_time => Time.current())
    deadline = time_off_request.start_time.prev_week.beginning_of_week.change(:hour => 17)
    time_off_request.distance_of_time.should == "passed " + distance_of_time_in_words(time_off_request.submission, deadline, include_seconds=false)
  end

  it "should detect expired request" do
    time_off_request = TimeOffRequest.create!(:user_id => @me.id, :start_time => Time.current().prev_week, :end_time => Time.current())
    time_off_request.is_expired?.should be_true
  end
  
  it "should detect invalid time" do
    time_off_request =  TimeOffRequest.create!(:user_id => @me.id, :start_time => Time.current(), :end_time => Time.current().prev_week)
    time_off_request.isNotTimeValid?.should be_true
  end
end
