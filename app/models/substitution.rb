class Substitution < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_one :entry
    validates_presence_of :entry

    def from_user
      users[0]
    end

    def to_user
      if self.users.size < 2
        nil
      else
        users[1]
      end
    end

    def is_evening?
      start = self.entry.start_time.hour
      start >= 17 and start < 22
    end

    def is_day?
      start = self.entry.start_time.hour
      start >= 8 and start < 17
    end

    def is_night?
      start = self.entry.start_time.hour
      start >= 22 or start < 8
    end

    def is_expired?
      self.entry.start_time < Time.current
    end
end
