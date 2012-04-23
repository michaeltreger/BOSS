class User < ActiveRecord::Base
  has_many :calendars
  has_and_belongs_to_many :substitutions
  has_many :preference
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
  
end
