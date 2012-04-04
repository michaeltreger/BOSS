class User < ActiveRecord::Base
  has_many :calendar
  belongs_to :substitution
  #has_one :preference
  belongs_to :entry
  belongs_to :lab
  validates_presence_of :type, :name
end
