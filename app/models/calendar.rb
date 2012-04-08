class Calendar < ActiveRecord::Base
    belongs_to :lab
    has_many :entries
    belongs_to :user
    validates_presence_of :calendar_type, :name

    #This should help with abstraction so we can use calendar.owner
    #instead of calendar.user which is ambiguious.
    def owner
        @user
    end
    
    def update_calendar(entries)

      self.entries.clear
      
      entries.each do |ent|
        ent.delete("start")
        ent.delete("end")
        ent.delete("type")
        e = Entry.find_by_id(ent["id"].to_i)
        ent.delete("id")
        if e.blank?
          e = Entry.create(ent)
        else
          e.update_attributes!(ent)
        end
        self.entries << e
          
                            
        

      end
    end

end
