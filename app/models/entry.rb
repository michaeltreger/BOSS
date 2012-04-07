class Entry < ActiveRecord::Base
    has_one :user
    belongs_to :substitution
    belongs_to :calendar
    belongs_to :lab
    validates_presence_of :start_time, :end_time, :repeating, :finalized

    #This might be useful down the line.
    def duration
        ((@start_time.minus_with_coercion(@end_time)/3600).round
    end

end
