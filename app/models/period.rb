class Period < ActiveRecord::Base
  has_many :calendars, :dependent => :destroy
  has_many :preferences, :dependent => :destroy
  validates_presence_of :start_date, :end_date, :name

  after_save :create_availability_calendars_and_preferences

  def self.current
    now = Time.now
    periods = where(:visible=>true).where("start_date <= '#{now}'").where("end_date >= '#{now}'")
    if periods.length > 1
      periods = periods.where(:exception=>true)
    end
    periods.first
  end

  def create_availability_calendars_and_preferences
    # TODO transactions?
    #User.find_all_by_user_type(User::EMPLOYEE).each do |user|
    User.all.each do |user|
      avail_calendar = Calendar.create!(:name=> "#{user.name}'s #{name} Availabilities",
                                        :calendar_type=>Calendar::AVAILABILITY)
      pref = Preference.create!()

      user.calendars << avail_calendar
      user.preference << pref
      user.save!
      calendars << avail_calendar
      preferences << pref
    end
  end

end
