require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Then /^I should see a description "([^"]*)"$/ do |arg1|
   if page.respond_to? :should
    page.should have_content(arg1)
   else
    assert page.has_content?(arg1)
   end
end

Given /^I should see a request starts at "([^"]*)" and ends at "([^"]*)" with name "([^"]*)"$/ do |arg1, arg2, arg3|
  if page.respond_to? :should
    page.should have_content(DateTime.parse(arg1).strftime('%a, %m/%d/%Y %I:%M%p'))
    page.should have_content(DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p'))
    page.should have_content(arg3)
  else
    assert page.has_content?(DateTime.parse(arg1).strftime('%a, %m/%d/%Y %I:%M%p'))
    assert page.has_content?(DateTime.parse(arg2).strftime('%a, %m/%d/%Y %I:%M%p'))
    assert page.has_content?(arg3)
  end
end
