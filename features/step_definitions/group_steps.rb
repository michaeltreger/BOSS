require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^the following groups exist:$/ do |table|
    table.hashes.each do |group|
        Group.create!(group)
    end
end

When /^I select "([^"]*)" from the menu$/ do |arg1|
    step "I select \"#{arg1}\" from \"user_groups\""
end

When /^I press remove on "([^"]*)"$/ do |arg1|
    find(:xpath, "//a[contains(@href,'Groups/#{Group.find_by_name(arg1).id}/remove')]").click
end

When /^I press destroy on "([^"]*)"$/ do |arg1|
    find(:xpath, "//a[contains(@href,'/groups/#{Group.find_by_name(arg1).id}') and @data-method='delete']").click
end

When /^I edit the group "([^"]*)"$/ do |arg1|
    visit "/admin/groups/#{Group.find_by_name(arg1).id}/edit"
end
