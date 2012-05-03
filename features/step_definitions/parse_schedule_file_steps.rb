require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Then /^Alice should have (\d+) entry which starts at "([^"]*)" and ends at "([^"]*)"$/ do |arg1, arg2, arg3|
  user = User.find_by_name("Alice")
  user.shift_calendar.entries.count.should == Integer(arg1)
  user.shift_calendar.entries[0].start_time.strftime('%a, %m/%d/%Y %I:%M%p').should == DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p')
  user.shift_calendar.entries[0].end_time.strftime('%a, %m/%d/%Y %I:%M%p').should == DateTime.parse(arg3).strftime('%a, %m/%d/%Y %I:%M%p')
end
