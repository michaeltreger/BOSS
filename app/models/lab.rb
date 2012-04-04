class Lab < ActiveRecord::Base
    has_one :calendar
    has_many :entries
    has_many :users, :through => :lab_users
    validates_presence_of :name, :initials, :max_employees, :min_employees

end
