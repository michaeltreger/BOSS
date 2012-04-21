class Period < ActiveRecord::Base
  has_many :calendars, :dependent => :destroy

  def create_calendars
    # TODO transactions?
    User.all.each do |user|
      availability_calendar = Calendar.create!(:name=> "#{user.name} #{name} Availabilities", 
                                  :calendar_type=>Calendar::AVAILABILITY, :user_id=>user.id, :period_id=>id)
      shifts_calendar = Calendar.create!(:name=> "#{user.name} #{name} Shifts", 
                                  :calendar_type=>Calendar::SHIFTS, :user_id=>user.id, :period_id=>id)

      user.calendars << availability_calendar
      user.calendars << shifts_calendar
      user.save!
      calendars << availability_calendar
      calendars << shifts_calendar
    end
  end

end
