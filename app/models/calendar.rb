class Calendar < ActiveRecord::Base
    belongs_to :lab
    has_many :entries
    belongs_to :user
    belongs_to :period
    validates_presence_of :calendar_type, :name#, :period

    validate :check_constraints

    AVAILABILITY = 0
    SHIFTS = 1
    LAB = 2
    SNAPSHOT = 3

    #This should help with abstraction so we can use calendar.owner
    #instead of calendar.user which is ambiguious.
    def owner
      user_id
    end

    def lab?
      calendar_type == LAB
    end

    def shift?
      calendar_type == SHIFTS
    end

    def availability?
      calendar_type == AVAILABILITY
    end

    def canAdd(candidate_entry)
      # first do hour limit check
      if (work_hours(candidate_entry.start_time) + candidate_entry.duration) > user.hour_limit
        return false
      end

      # now check overlap
      entries.each do |e|
        if e.overlaps_with_or_back_to_back(candidate_entry)
          return false
        end
      end
      return true
    end

    def update_calendar(entries)
      old_entry_ids = self.entries.map{ |e| e.id}
      self.entries.clear

      entries.each do |ent|
        e = Entry.find_by_id(ent["id"].to_i)
        ent.delete("id")
        ent.delete("readOnly")
        if e.blank?
          e = Entry.create(ent)
        else
          e.update_attributes!(ent)
        end
        self.entries << e
        old_entry_ids.delete(e.id)
      end
      self.save!
      Entry.delete(old_entry_ids)
    end

    def work_hours(time)
      if calendar_type == SHIFTS
        day = time.wday
        monday = time - time.wday.day + 1.day + 8.hour
        nextMonday = monday + 7.day
        hours = 0
        for entry in self.entries
          if !entry.nil? && entry.start_time > monday && entry.start_time < nextMonday
            hours += entry.duration
          end
        end
        return hours
      end
    end

    def check_constraints
      if calendar_type == AVAILABILITY
        total_unavail = 0
        weekday_unavail = 0

        entries.each do |e|
          if e.entry_type == 'class' or e.entry_type == 'obligation' or e.entry_type == 'closed'
            if e.duration > 0
              if e.start_time.wday != 0 and e.start_time.wday != 6
                weekday_unavail += e.duration
              end
              total_unavail += e.duration
            end
          end
        end

        total_avail = 24*7 - total_unavail
        weekday_avail = 14*5 - weekday_unavail
        if (total_avail > 45 and weekday_avail > 15) or total_avail > 30 or weekday_avail > 15
          return true
        else
          return false
          errors[:base] = "not a valid calendar"
        end

      end
    end

    def check_continuity
      if calendar_type == SHIFTS or calendar_type == LAB
        entries = Entry.where(:calendar_id => self.id)
        entries.each do |e1|
          entries.each do |e2|
            if Entry.find_by_id(e1.id).nil? and Entry.find_by_id(e2.id).nil?
            else
              if e1.lab_id == e2.lab_id and e1.user_id == e2.user_id
                if e1.end_time == e2.start_time or e2.end_time == e1.start_time
                  inverse = false
                  if e2.end_time == e1.start_time
                    inverse = true
                  end
                  description = ""
                  if e1.description and e2.description
                    if e1.description != e2.description
                      description << e1.description << e2.description
                    else
                      description << e1.description
                    end
                  elsif e1.description
                    description << e1.description
                  elsif e2.description
                    description << e2.description
                  end
                  startTime = inverse ? e2.start_time : e1.start_time
                  endTime = inverse ? e1.end_time : e2.end_time
                  newEntry = Entry.create!(:entry_type => 'shift', :start_time => startTime, :end_time => endTime, :description => description, :calendar_id => self.id, :user_id => e1.user_id, :lab_id => e1.lab_id)
                  Entry.destroy(e1.id)
                  Entry.destroy(e2.id)
                  self.entries = Entry.where(:calendar_id => self.id)
                  self.check_continuity
                end
              end
            end
          end
        end
      end
    end
end

