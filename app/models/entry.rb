class Entry < ActiveRecord::Base
    has_many :users
    belongs_to :substitution
    belongs_to :calendar
    belongs_to :lab
    validates_presence_of :start_time, :end_time, :repeating, :finalized

end
