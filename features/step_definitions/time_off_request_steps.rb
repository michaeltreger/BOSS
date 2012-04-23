require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following time\-off requests for Alice exist:$/ do |request_table|
  request_table.hashes.each do |request|
    TimeOffRequest.create!(request)
  end
end

Given /^I should see a request starts at "([^"]*)" and ends at "([^"]*)"$/ do |arg1, arg2|
  if page.respond_to? :should
    page.should have_content(DateTime.parse(arg1).strftime('%a, %m/%d/%Y %I:%M%p'))
    page.should have_content(DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p'))
  else
    assert page.has_content?(DateTime.parse(arg1).strftime('%a, %m/%d/%Y %I:%M%p'))
    assert page.has_content?(DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p'))
  end
end


When /^I follow "([^"]*)" on a request starts at "([^"]*)" and ends at "([^"]*)"$/ do |arg1, arg2, arg3|
  click_link(arg1)
end

Then /^I should not see a request starts at "([^"]*)" and ends at "([^"]*)"$/ do |arg1, arg2|
   if page.respond_to? :should
    page.should have_no_content(DateTime.parse(arg1).strftime('%a, %m/%d/%Y %I:%M%p'))
    page.should have_no_content(DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p'))
  else
    assert page.has_no_content?(DateTime.parse(arg1).strftime('%a, %m/%d/%Y %I:%M%p'))
    assert page.has_no_content?(DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p'))
  end
end

When /^I follow "([^"]*)" on description page$/ do |arg1|
  click_link(arg1)
end

Then /^I should see "([^"]*)" on my requests page$/ do |arg1|
  if page.respond_to? :should
    page.should have_content(arg1)
  else
    assert page.has_content?(arg1)
  end
end

