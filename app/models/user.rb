class User < ActiveRecord::Base
  has_many :calendars, :dependent=>:destroy
  has_and_belongs_to_many :substitutions
  has_many :preference, :dependent=>:destroy
  has_many :time_off_requests, :dependent=>:destroy
  belongs_to :entry
  belongs_to :lab
  has_many :group_users
  has_many :groups, :through => :group_users
  validates_presence_of :name
  if not Rails.env.test?
    validates_presence_of :email, :cas_user
    validates_presence_of :initials, :if => Proc.new { |user| user.activated? }
    validates_uniqueness_of :cas_user
  end

  validates_uniqueness_of :email
  validates_uniqueness_of :initials

  after_create :make_calendars

  ADMINISTRATOR = Group.find_or_create_by_name(:name => "Administrators", :description => "All users in this group are BOS administrators.").id
  SCHEDULER = Group.find_or_create_by_name(:name => "Schedulers", :description => "All users in this group are BOS schedulers.").id
  EMPLOYEE = Group.find_or_create_by_name(:name => "All Users", :description => "All users in this group by default.").id


  def make_calendars
    calendars << Calendar.create!(:name=> "#{name}'s Shifts",
                                  :calendar_type=>Calendar::SHIFTS)
    Period.all.each do |p|
      make_period_specific_calendars(p)
      p.save!
    end
  end

  def make_period_specific_calendars(p)
    avail_calendar = Calendar.create!(:name=> "#{name}'s #{p.name} Availabilities",
                                      :calendar_type=>Calendar::AVAILABILITY)
    if !p.exception
      monday = Time.now.beginning_of_week
      5.times do |day|
        avail_calendar.entries << Entry.create(:start_time=>monday + day.days + 2.hours, :end_time=>monday + day.days + 8.hours, :entry_type=>"closed")
      end
      avail_calendar.entries << Entry.create(:start_time=>monday + 4.days + 22.hours, :end_time=>monday + 5.days + 9.hours, :entry_type=>"closed")
      avail_calendar.entries << Entry.create(:start_time=>monday + 5.days + 22.hours, :end_time=>monday + 6.days + 13.hours, :entry_type=>"closed")
    end

    pref = Preference.create!()

    calendars << avail_calendar
    preference << pref

    p.calendars << avail_calendar
    p.preferences << pref
  end

  def isAdmin?
    self.groups.include? Group.find(ADMINISTRATOR)
  end

  def isScheduler?
    self.groups.include? Group.find(SCHEDULER)
  end

  def isAdminOrScheduler?
    isAdmin? or isScheduler?
  end

  def hour_limit
    if groups.size > 0
      all_hour_limits = groups.map{|g| g.hour_limit}
      hour_limit = all_hour_limits.max
    else
      hour_limit = 20
    end
  end

  def availability_calendar(period)
    calendars.where(:calendar_type=>Calendar::AVAILABILITY, :period_id=>period.id).first
  end

  def shift_calendar
    calendars.where(:calendar_type=>Calendar::SHIFTS).first
  end

  def current_preference(period)
    preference.where(:period_id=>period.id).first
  end

  def self.types
    [["Admin", ADMINISTRATOR], ["Sched", SCHEDULER], ["Employee", EMPLOYEE]]
  end

end
