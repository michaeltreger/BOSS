class Calendar < ActiveRecord::Base
    belongs_to :lab
    has_many :entries
    belongs_to :user
    validates_presence_of :calendar_type, :name

    PREFERENCE = 0
    SHIFTS = 1

    #This should help with abstraction so we can use calendar.owner
    #instead of calendar.user which is ambiguious.
    def owner
      user_id
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

end
