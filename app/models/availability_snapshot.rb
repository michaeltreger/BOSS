class AvailabilitySnapshot < ActiveRecord::Base
  serialize :availabilites, Hash
end
