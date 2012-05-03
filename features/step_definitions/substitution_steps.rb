require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following substitutions exist:$/ do |substitutions_table|
  substitutions_table.hashes.each do |s|
    substitution = {:entry => Entry.find_by_description(s[:entry_description]),
                    :description => s[:description]}
    new_sub = Substitution.create(substitution)
    owner = User.find_by_id(s[:from_user_id])
    new_sub.users << owner
    if (s[:to_user_id] != "nil")
      target = User.find_by_id(s[:to_user_id])
      new_sub.users << target
    end
    new_sub.save!
  end
end

When /^I select the entry with description "([^"]*)" for substitution$/ do |entry_description|
  entry_id = Entry.find_by_description(entry_description).id
  choose('entry_' + entry_id.to_s)
end

When /^I select the user with initials "([^"]*)" for my substitution$/ do |initials|
  select(initials)
end

When /^I check the substitution "([^"]*)"$/ do |sub|
  targetSub = Substitution.find_by_description(sub)
  id = 'entries[' + targetSub.id.to_s + ']'
  check(id)
end

When /^I choose to substitute a partial shift$/ do
  check('partial_shift')
end

When /^I assign the substitution to "([^"]*)"$/ do |user|
  targetUser = User.find_by_name(user)
  select(targetUser.initials)
end

When /^I put the substitution in "([^"]*)"$/ do |calendar|
  select(calendar)
end

When /^I delete my substitution with description "([^"]*)"$/ do |sub_description|
  sub_id = Substitution.find_by_description(sub_description).id
  click_link('delete_' + sub_id.to_s)
end

Then /^I should not see the entry with description "([^"]*)" for substitution$/ do |entry_description|
  entry_id = Entry.find_by_description(entry_description).id
  assert !(page.html =~ /.*<td><input checked="checked" id="#{entry_id}" name="Select" type="radio".*/m)
end

Then /^"My Posted Substitutions" should have (\d+) entries$/ do |num|
  numRows = ((page.all('table#my_subs tr').count) -1 )
  if numRows < 0
    numRows = 0
  end
  numRows.should == Integer(num)
end


Then /^"My Posted Substitutions" should contain "([^"]*)"$/ do |entry|
  a = 'My Posted Substitutions'
  b = entry
  c = 'Available Substitutions'
  assert page.html =~  /.*#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}.*/m
end


Then /^"My Posted Substitutions" should contain "([^"]*)" for the user with initials "([^"]*)"$/ do |entry, initials|

  a = 'My Posted Substitutions'
  b = entry
  c = initials
  d = 'Available Substitutions'
  assert page.html =~  /.*#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}.*#{Regexp.quote(d)}.*/m
end


Then /^"My Posted Substitutions" should not contain "([^"]*)"$/ do |entry|
  a = 'My Posted Substitutions'
  b = entry
  c = 'Available Substitutions'
  assert !(page.html =~  /#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}/m)
end

Then /^"Reserved Substitutions" should have (\d+) entries$/ do |num|
  page.all('tr.reservedsub').count.should == Integer(num)
end


Then /^"Reserved Substitutions" should contain "([^"]*)"$/ do |entry|
  a = 'Reserved For Me'
  b = entry
  c = 'Available for Anyone'
  assert page.html =~  /.*#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}.*/m
end


Then /^"Reserved Substitutions" should contain "([^"]*)" for the user with initials "([^"]*)"$/ do |entry, initials|
  a = 'Reserved For Me'
  b = entry
  c = initials
  d = 'Available for Anyone'
  assert page.html =~  /.*#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}.*#{Regexp.quote(d)}.*/m
end


Then /^"Reserved Substitutions" should not contain "([^"]*)"$/ do |entry|
  a = 'Reserved For Me'
  b = entry
  c = 'Available for Anyone'
  assert !(page.html =~  /#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}/m)
end

Then /^"Available Substitutions" should have (\d+) entries$/ do |num|
  (page.all('tr.available_subs').count).should == Integer(num)
end


Then /^"Available Substitutions" should contain "([^"]*)"$/ do |entry|
  a = 'Available for Anyone'
  b = entry
  c = 'Take Selected Substitutions'
  assert page.html =~  /.*#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}.*/m
end


Then /^"Available Substitutions" should contain "([^"]*)" for the user with initials "([^"]*)"$/ do |entry, initials|
  a = 'Available for Anyone'
  b = initials
  c = entry
  d = 'Take Selected Substitutions'
  assert page.html =~  /.*#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}.*#{Regexp.quote(d)}.*/m
end


Then /^"Available Substitutions" should not contain "([^"]*)"$/ do |entry|
  a = 'Available for Anyone'
  b = entry
  c = 'Take Selected Substitutions'
  assert !(page.html =~  /#{Regexp.quote(a)}.*#{Regexp.quote(b)}.*#{Regexp.quote(c)}/m)
end
