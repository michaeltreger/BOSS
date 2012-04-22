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

