require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))


Given /^the following periods exist:$/ do |periods_table|
  periods_table.hashes.each do |period|
    period[:start_date] = Time.current-2.months
    period[:end_date] = Time.current+2.months
    period[:visible] = true
    Period.create!(period)
  end
end
