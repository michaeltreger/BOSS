class Period < ActiveRecord::Base
  has_many :calendars, :dependent => :destroy
  has_many :preferences, :dependent => :destroy
  validates_presence_of :start_date, :end_date, :name

  after_create :create_availability_calendars_and_preferences

  def self.current
    now = Time.current
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
      user.make_period_specific_calendars(self)
      user.save!
    end
  end

end
