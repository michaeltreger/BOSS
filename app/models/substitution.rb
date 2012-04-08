class Substitution < ActiveRecord::Base
    has_many :users
    has_one :entry
    validates_presence_of :entry

    def set_substituter(user)
      self.users[0] = user
    end

end
