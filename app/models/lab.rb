class Lab < ActiveRecord::Base
    has_one :calendar, :dependent => :destroy
    has_many :entries
    has_many :users, :through => :lab_users
    has_many :group_labs
    has_many :groups, :through => :group_labs
    has_attached_file :text_file,
                      :url => "/assets/:basename.:extension",
                      :path => ":rails_root/public/assets/:basename.:extension"
    validates_presence_of :name, :initials, :max_employees, :min_employees
    validates_attachment_size :text_file, :less_than => 20.kilobytes

    after_create :make_calendar
    #Could potentially be very useful.
    def capacity
        @max_employees - @users.length
    end

    def make_calendar
      self.calendar = Calendar.create!(:name=> "#{initials} Schedule",
                                       :calendar_type=>Calendar::LAB)
    end

    def is_week_empty?(startTime, endTime)
      entries = Entry.where(:lab_id => self.id)

      entries.each do |e|
        if (e.start_time > startTime) && (e.start_time < endTime)
          return false
        elsif (e.end_time > startTime) && (e.end_time < endTime)
          return false
        else
          return true
        end
      end
    end

    #Struture:2 dimension array DayArray[EmployeesArray[Employee => 0/1/2/3]]]  (0 means the whole hour, 1 means first half hour, 2 means second half hour
    #The first row store info of lab(first one) and time(second one as start, third one as end)
    #Step1: Parse the info into the 3D array.
    #Step2: Iterate through the 3D array and make entries and subs.


    def read_schedule(fileName)

      if !(file = File.open(fileName, 'r'))
        abort("Can not open file : #{fileName}")
      end

      timeTable = Array.new(25) {Array.new(7){{}}}
      tRN = 1 #tRN = timeRowNumber
      dCN = 0 #dCN = dayColumnNumber
      while(!file.eof)
        line = ""

        begin
          char = file.getc.chr
          line += char
        end while char != 10.chr and char != 13.chr and !file.eof
        fields = line.split('|')

        if (fields.size == 3)
          timeTable[0][0].merge!({"initials" => fields[1].strip})
          timeTable[0][1].merge!({"name" => fields[2].strip})
        end

        if (fields.size == 1)
          if dates = fields[0].match(/(([0-9]+)\.([0-9]+))-(([0-9]+)\.([0-9]+))/)
            timeTable[0][2].merge!({"start_time_month" => dates[2]})
            timeTable[0][3].merge!({"start_time_day" => dates[3]})
            timeTable[0][4].merge!({"end_time_month" => dates[5]})
            timeTable[0][5].merge!({"end_time_day" => dates[6]})
          end
        end

        #use row index to indicate time, no need to parse time.
        if ((fields.size == 10) and (times = fields[1].match(/([0-9]+)-([0-9]+)/)))
          #  if (!currentTime) {
          #      currentTime = times[1];
          #      if (times[1] < 8 && today)#how about 24 hours in final weeks
          #        currentTime +=12
          #      end
          #    else currentTime += 1
          #    end#don't know whether useful or not
          #  end
          if fields.size == 10 and !fields[1].match(/(\=+)|(\-\-+)/)
            for i in 2..8
              empInits = fields[i].split(/\s+/)
              for j in 0..(empInits.size-1)
                if((empInits[j].upcase != "CLOSED") && (empInits[j] != ""))
                  empInits[j] << " "
                  empArr = empInits[j].split('/')
                  if empArr.size == 2
                    if empArr[0] == ""
                      timeTable[tRN][dCN].merge!({empArr[1].strip => 2})
                    elsif empArr[1] == " "
                      timeTable[tRN][dCN].merge!({empArr[0].strip => 1})
                    end

                  elsif empArr.size == 3
                    timeTable[tRN][dCN].merge!({empArr[0].strip => 1})
                    timeTable[tRN][dCN].merge!({empArr[2].strip => 2})

                  elsif empArr.size == 1
                    #puts timeTable
                    timeTable[tRN][dCN].merge!({empArr[0].strip => 0})
                  end
                end
              end
              dCN += 1
              dCN = dCN % 7
            end
          end
          tRN += 1
        end
      end
      return timeTable
    end

end
