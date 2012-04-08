require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following substitutions exist:$/ do |substitions_table|
  substitutions_table.hashes.each do |substitution|
    Calendar.create!(substitution)
  end
end

When /^I select the entry with id \d+ for substitution$/ do |sub_id|

