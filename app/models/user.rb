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
    validates_presence_of :user_type, :email, :cas_user
    validates_presence_of :initials, :if => Proc.new { |user| user.activated? }
    validates_uniqueness_of :cas_user
  end

  validates_uniqueness_of :email
  validates_uniqueness_of :initials

  after_create :make_calendars

  ADMINISTRATOR = -1
  SCHEDULER = 0
  EMPLOYEE = 1

  def make_calendars
    calendars << Calendar.create!(:name=> "#{name}'s Shifts",
                                  :calendar_type=>Calendar::SHIFTS)
    Period.all.each do |p|
      avail_calendar = Calendar.create!(:name=> "#{name}'s #{p.name} Availabilities",
                                        :calendar_type=>Calendar::AVAILABILITY)
      pref = Preference.create!()

      calendars << avail_calendar
      preference << pref

      p.calendars << avail_calendar
      p.preferences << pref
      p.save!
    end
  end

  def isAdmin?
    user_type == ADMINISTRATOR or user_type == SCHEDULER
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
