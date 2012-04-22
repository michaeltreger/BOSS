class User < ActiveRecord::Base
  has_many :calendars
  has_and_belongs_to_many :substitutions
  has_many :preference
  has_many :time_off_requests
  belongs_to :entry
  belongs_to :lab
  belongs_to :group
  validates_presence_of :name
  validates_presence_of :user_type, :if => :approved?
  validates_presence_of :initials, :if => :approved?

  ADMIN = 0
  EMPLOYEE = 1

  def isAdmin?
    user_type == ADMIN
  end
  
end
