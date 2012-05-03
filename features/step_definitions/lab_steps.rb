require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^the following labs exist:$/ do |lab_table|
  lab_table.hashes.each do |lab|
    Lab.create(lab)
  end
end

Given /^the lab "([^"]*)" is in the unit "([^"]*)"$/ do |arg1, arg2|
    lab = Lab.find_by_name(arg1)
    unit = Unit.find_by_name(arg2)
    unit.labs << lab
    unit.save!
end

