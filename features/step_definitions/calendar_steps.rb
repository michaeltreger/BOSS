require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following calendars exist:$/ do |calendars_table|
  calendars_table.hashes.each do |calendar|
    Calendar.create!(calendar)
  end
end

Given /^the calendar "([^"]*)"$/" has the following entries do |calendar_name, entries_table|
  calendar_id = (Calendar.find_by_name(calendar_name)).id
  entries_table.hashes.each do |entry|
    entry[:calendar_id] = calendar_id
    Entry.create!(calendar)
  end
end
