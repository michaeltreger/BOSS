require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^the following time edits exist:$/ do |te_table|
  te_table.hashes.each do |te|
    TimeEdit.create!(te)
  end
end

