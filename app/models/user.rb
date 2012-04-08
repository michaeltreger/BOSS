class User < ActiveRecord::Base
  has_many :calendars
  has_and_belongs_to_many :substitutions
  has_one :preference
  belongs_to :entry
  belongs_to :lab
  belongs_to :group
  validates_presence_of :name
  validates_presence_of :user_type, :if => :approved?
  validates_presence_of :initials, :if => :approved?

  def isAdmin?
    user_type == 0
  end

end
