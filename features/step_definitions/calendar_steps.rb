require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following calendars exist:$/ do |calendars_table|
  period = Period.create!(:name=>"Spring 2012", :start_date => "2012-1-20", :end_date => "2012-5-20")
  calendars_table.hashes.each do |calendar|
    calendar[:period_id] = period.id
    new_calendar = Calendar.create!(calendar)
  end
end

Given /^the calendar "([^"]*)" has the following entries:$/ do |calendar_name, entries_table|
  calendar = Calendar.find_by_name(calendar_name)
  entries_table.hashes.each do |entry|
    entry[:lab] = Lab.find_by_name(entry[:lab])
    entry[:calendar_id] = calendar.id
    Entry.create!(entry)
  end
end

When /I select the interval "([^"]*)" to "([^"]*)" as "([^"]*)"$/ do |start_time, end_time, entry_type|
  calendar_id = current_path.split('/')[-1]
  entry = {:calendar_id=>calendar_id, :start_time=>start_time, :end_time=>end_time, :entry_type=>entry_type}
  Entry.create!(entry)
end


When /^I view the calendar$/ do
  visit current_path+".json"
end
