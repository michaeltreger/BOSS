class Lab < ActiveRecord::Base
    has_one :calendar, :dependent => :destroy
    has_many :entries
    has_many :users, :through => :lab_users
    validates_presence_of :name, :initials, :max_employees, :min_employees

    after_create :make_calendar
    #Could potentially be very useful.
    def capacity
        @max_employees - @users.length
    end

    def make_calendar
      self.calendar = Calendar.create!(:name=> "#{initials} Schedule",
                                       :calendar_type=>Calendar::LAB)
    end
end
