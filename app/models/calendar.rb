class Calendar < ActiveRecord::Base
    belongs_to :lab
    has_many :entries
    belongs_to :user
    belongs_to :period
    validates_presence_of :calendar_type, :name

    #validate_with :check_constraints

    AVAILABILITY = 0
    SHIFTS = 1

    #This should help with abstraction so we can use calendar.owner
    #instead of calendar.user which is ambiguious.
    def owner
      user_id
    end

    def shift?
      calendar_type == SHIFTS
    end


    def full_name
      start = ''
      if user && user.initials
        start = user.initials
      elsif lab && lab.name
        start = lab.name
      end
      return start + ': ' + name
    end

    def update_calendar(entries)
      old_entry_ids = self.entries.map{ |e| e.id}
      self.entries.clear

      entries.each do |ent|
        e = Entry.find_by_id(ent["id"].to_i)
        ent.delete("id")
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

    def work_hours
      hours = 0
      for entry in self.entries
        if !entry.nil?
          hours += entry.duration
        end
      end
      return hours
    end


    def check_constraints
      debugger
      if calendar_type == AVAILABILITY
        total_unavail = 0
        weekday_unavail = 0

        entries.each do |e|
          if e.entry_type == 'class' or e.entry_type == 'obligation'
            if e.start_time.wday != 0 and e.start_time.wday != 6
              weekday_unavail += e.duration
            end
            total_unavail += e.duration
          end
        end

        total_avail = 126 - total_unavail
        weekday_avail = 90 - weekday_unavail
        if total_avail > 45 and weekday_avail > 15
          return true
        elsif total_avail > 30
          return true
        elsif weekday_avail > 15
          return true
        else
          return false
        end

      end
    end

end
