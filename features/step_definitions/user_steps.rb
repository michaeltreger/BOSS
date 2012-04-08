require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^I am logged in as "([^"]*)"$/ do |n|
  user_id = (User.find_by_name(n)).id
  visit '/test_setuser/' + user_id.to_s
end

Given /^the following users exist:$/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

