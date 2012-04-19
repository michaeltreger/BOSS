require 'action_view'
include ActionView::Helpers::DateHelper

class TimeOffRequest < ActiveRecord::Base

def isNotTimeValid?
  self.start_time > self.end_time
end

def distance_of_time
  @now = Time.current()
  if @now >= self.start_time
    "passed " +  distance_of_time_in_words(@now, self.start_time, include_seconds=false)
  else
    distance_of_time_in_words(@now, self.start_time, include_seconds=false) + " left"
  end
end

end
