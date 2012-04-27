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
      Period.find_all_by_visible(true).each do |p|
        cal = Calendar.create!(:name=> "#{@lab.initials} #{p.name}",
                               :calendar_type=>Calendar::LAB)
        @lab.calendar = cal
        p.calendars << cal
        p.save!
      end
    end
end
