require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following substitutions exist:$/ do |substitutions_table|
  substitutions_table.hashes.each do |substitution|
    substitution[:entry] = Entry.find_by_id(substitution[:entry_id])
    new_sub = Substitution.create!(substitution)
    owner = User.find_by_id(substitution[:user_id])
    new_sub.users << owner
    new_sub.save!
  end
end

When /^I select the entry with id (\d+) for substitution$/ do |entry_id|
  choose(entry_id.to_s)
end

When /^I delete my substitution with id (\d+)$/ do |sub_id|
  click_link('delete_' + sub_id.to_s)
end

Then /^I should not see the entry with id (\d+) for substitution$/ do |entry_id|
  assert !(page.html =~ /.*<td><input checked="checked" id="#{entry_id}" name="Select" type="radio".*/m)
end

Then /^"My Posted Substitutions" should have (\d+) entries$/ do |num|
  page.all('table#my_subs tr').count.should == Integer(num) + 1
end


Then /^"My Posted Substitutions" should contain "([^"]*)"$/ do |entry|
  a = 'My Posted Substitutions'
  b = entry
  c = 'Available Substitutions'
  assert page.html =~  /#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}/m
end

Then /^"My Posted Substitutions" should not contain "([^"]*)"$/ do |entry|
  a = 'My Posted Substitutions'
  b = entry
  c = 'Available Substitutions'
  assert !(page.html =~  /#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}/m)
end

