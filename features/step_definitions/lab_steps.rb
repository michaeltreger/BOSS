require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^the following labs exist:$/ do |lab_table|
  lab_table.hashes.each do |lab|
    Lab.create(lab)
  end
end
