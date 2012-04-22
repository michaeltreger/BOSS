require 'action_view'
include ActionView::Helpers::DateHelper

class TimeOffRequest < ActiveRecord::Base
  belongs_to :user

def isNotTimeValid?
  self.start_time > self.end_time
end

def distance_of_time
  deadline = self.start_time.prev_week.beginning_of_week.change(:hour => 17)
  self.submission = Time.current
  distance = distance_of_time_in_words(self.submission, deadline, include_seconds=false)
  if self.submission >= deadline
    "passed " +  distance
  else
    distance + " left"
  end
end

end
