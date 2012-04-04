class Substitution < ActiveRecord::Base
    has_many :users
    has_one :entry
    validates_presence_of :entry, :users

end
