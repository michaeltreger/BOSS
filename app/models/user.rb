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
  #validates_presence_of :user_type
  #validates_presence_of :initials

  ADMIN = 0
  EMPLOYEE = 1

  def isAdmin?
    user_type == ADMIN
  end
  
  def availability_calendar(period)
    calendars.where(:calendar_type=>Calendar::AVAILABILITY, :period_id=>period.id).first
  end
  
  def shift_calendar(period)
    calendars.where(:calendar_type=>Calendar::SHIFTS, :period_id=>period.id).first
  end

end
