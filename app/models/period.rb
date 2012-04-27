class Period < ActiveRecord::Base
  has_many :calendars, :dependent => :destroy
  has_many :preferences, :dependent => :destroy

  def get_shift_calendar(user_id)
    i = calendars.index{|c| (c.user.id == user_id) && (c.calendar_type == Calendar::SHIFTS)}
    if i
      calendars[i]
    else
      i
    end
  end

  def self.current
    now = Time.now
    where(:visible=>true).where("start_date <= '#{now}'").where("end_date >= '#{now}'").first
  end

  def create_calendars
    # TODO transactions?
    User.all.each do |user|
      avail_calendar = Calendar.create!(:name=> "#{user.name}'s #{name} Availabilities",
                                        :calendar_type=>Calendar::AVAILABILITY)
      shift_calendar = Calendar.create!(:name=> "#{user.name}'s #{name} Shifts",
                                        :calendar_type=>Calendar::SHIFTS)

      pref = Preference.create!()

      user.calendars << avail_calendar
      user.calendars << shift_calendar
      user.preference << pref
      user.save!
      calendars << avail_calendar
      calendars << shift_calendar
      preferences << pref
    end

    Lab.all.each do |lab|
      cal = Calendar.create!(:name=> "#{lab.initials} #{name}",
                             :calendar_type=>Calendar::LAB)
      lab.calendar = cal
      calendars << cal
      lab.save!
    end

  end

end
