
class Entry < ActiveRecord::Base
    has_one :user
    belongs_to :substitution
    belongs_to :calendar
    belongs_to :lab
    validates_presence_of :start_time, :end_time#, :repeating, :finalized

    #This might be useful down the line.
    def duration
      (end_time - start_time) / 1.hour
    end

    def overlaps_with_or_back_to_back(other_entry)
      if overlaps_with(other_entry)
        return true
      end
      if lab && other_entry.lab && ((start_time == other_entry.end_time) || (end_time == other_entry.start_time)) && (lab.id != other_entry.lab.id)
        return true
      end
      return false
    end

    def overlaps_with(other_entry)
      if (start_time > other_entry.start_time) && (start_time < other_entry.end_time)
        return true
      elsif (end_time > other_entry.start_time) && (end_time < other_entry.end_time)
        return true
      elsif (other_entry.start_time > start_time) && (other_entry.start_time < end_time)
        return true
      elsif (other_entry.end_time > start_time) && (other_entry.end_time < end_time)
        return true
      else
        return false
      end
    end
    
    def unavailable?
      entry_type == "closed" or entry_type == "obligtion" or entry_type == "class"
    end
end
