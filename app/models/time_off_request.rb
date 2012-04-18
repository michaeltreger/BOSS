class TimeOffRequest < ActiveRecord::Base

def isNotTimeValid?
  return self.start_time > self.end_time
end

end
