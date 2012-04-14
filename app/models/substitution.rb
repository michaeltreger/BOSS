class Substitution < ActiveRecord::Base
    has_and_belongs_to_many :users
    has_one :entry
    validates_presence_of :entry

    def get_from_user()
      self.users[0]
    end

    def get_to_user()
      self.users[1]
    end

end
