require 'action_view'
include ActionView::Helpers::DateHelper

class TimeOffRequest < ActiveRecord::Base
  belongs_to :user
  has_one :entry, :dependent => :destroy

  after_create :create_entry

  def is_expired?
    self.start_time < Time.current
  end

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

  def create_entry
    cal = User.find_by_id(user_id).availability_calendar(Period.current)
    self.entry = Entry.create!(:entry_type=>"time_off_request", :start_time=>self.start_time, :end_time=>self.end_time, :description=>self.description)
    cal.entries << self.entry
  end

end

