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

end
