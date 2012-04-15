class TimeEdit < ActiveRecord::Base
  validates_presence_of :user_id, :calendar_id, :start_time, :duration
end
