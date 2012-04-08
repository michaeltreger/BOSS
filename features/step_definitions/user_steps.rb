require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^I am logged in as "([^"]*)"$/ do |n|
  @current_user = User.find_by_name(n)
  cookies[:stub_user_id] = @current_user.id
end

Given /^the following users exist:$/ do |users_table|
  users_table.hashes.each do |user|
    User.create!(user)
  end
end

