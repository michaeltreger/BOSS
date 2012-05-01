class AvailabilitySnapshot < ActiveRecord::Base
  serialize :availabilities, Hash
end
