class User < ActiveRecord::Base
  has_many :calendars
  belongs_to :substitution
  has_one :preference
  belongs_to :entry
  belongs_to :lab
  belongs_to :group
  validates_presence_of :name
  validates_presence_of :type, :if => :approved?
  validates_presence_of :initials, :if => :approved?
  validates_presence_of :type, :if => :approved?

end
