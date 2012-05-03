require 'spec_helper'

describe Calendar do
  before :each do
    @user1 = User.create!({:name => 'anoriginalname', :activated => true, :initials => "ZZ"})
    @user2 = User.create!({:name => 'mockuser', :activated => true, :initials => ":)"})
    @calendar1 = Calendar.create!({:calendar_type => 1, :name => 'reallyimportant', :user_id => @user1.id})
    @calendar2 = Calendar.create!({:calendar_type => 1, :name => 'work', :user_id => @user2.id})
    @avail_calendar = Calendar.create!({:calendar_type => 0, :name => 'availability', :user_id => @user1.id})
    @lab1 = Lab.create!({:name => 'lab1', :initials => 'l1', :max_employees => 1000, :min_employees => 1})
    @lab2 = Lab.create!({:name => 'lab2', :initials => 'l2', :max_employees => 2000, :min_employees => 1999})
    @lab1_calendar = Calendar.create!({:calendar_type => 2, :name => 'MMF', :lab_id => @lab1.id})
    @originalentry = Entry.create!(:user_id => @user1.id, :calendar_id => @calendar1.id, :lab_id => @lab1.id, :start_time => '8:00am', :end_time => '12:00pm')
    @overlap = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '9:00am', :end_time => '1:00pm' )
    @backtobackdiff = Entry.create!(:user_id => @user1.id, :calendar_id => @calendar2.id, :lab_id => @lab2.id, :start_time => '12:00pm', :end_time => '1:00pm')
    @backtobacksame = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '12:00pm', :end_time => '1:00pm')
    @backtobacksame2 = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '1:00pm', :end_time => '2:00pm')
    @backtobacksame3 = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '2:00pm', :end_time => '3:00pm')
    @backtobacksame4 = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '3:00pm', :end_time => '4:00pm')
    @other_entry = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :start_time => '10:00pm', :end_time => '11:00pm')
  end
  describe "check if entry can be added to calendar" do
    it "should disallow overlapping entries" do
      @calendar1.canAdd(@overlap).should == false
    end
    it "should disallow back to back entries at different locations" do
      @calendar1.canAdd(@backtobackdiff).should == false
    end
    it "should allow back to back entries at the same location" do
      @calendar1.canAdd(@backtobacksame).should == true
    end
  end

  describe "check whether there are continuous entries at the same place" do
    it "should merge continuous entries" do
      @backtobacksame.calendar_id = @calendar1.id
      @backtobacksame.user_id = @calendar1.user_id
      @backtobacksame.save!

      @calendar1.entries.size.should == 2
      @calendar1.check_continuity
      @calendar1.entries.size.should == 2

      @backtobacksame2.calendar_id = @calendar1.id
      @backtobacksame2.user_id = @calendar1.user_id
      @backtobacksame3.calendar_id = @calendar1.id
      @backtobacksame3.user_id = @calendar1.user_id
      @backtobacksame4.calendar_id = @calendar1.id
      @backtobacksame4.user_id = @calendar1.user_id
      @backtobacksame2.save!
      @backtobacksame3.save!
      @backtobacksame4.save!

      @calendar2.entries = Entry.where(:calendar_id => @calendar2.id)
      @calendar2.entries.size.should == 3
      @calendar2.check_continuity
      @calendar2.entries.size.should == 3
    end

    describe "get owner" do
      it "should return the user id" do
        @calendar1.owner.should == @user1.id
      end
    end

    describe "check calendar type" do
      it "should return false while checking whehter it is lab" do
        @calendar1.lab?.should == false
      end

      it "should return true while checking whether it is shifts" do
        @calendar1.shift?.should == true
        end

      it "should return false while checking whether it is availability" do
        @calendar1.availability?.should == false
      end
    end

    describe "get the full name of the calendar" do
      it "should include the lab name if it is a lab calendar" do
        @lab1_calendar.full_name.should include(@lab1.name)
      end

      it "should include the initials if it is a shifts calendar of a availability calendar" do
        @calendar1.full_name.should include(@user1.initials)
      end
    end

    describe "get work hours of shifts calendar"do
      it "should return the work hours of the week of the specific time" do
        @calendar1.work_hours(@backtobacksame.start_time).should == 4
      end
    end

    describe "check whether an availability calendar is validate" do
      describe "should return true" do
        it "if total available time is greater than 45 and total week day available time is greater than 15" do
          @avail_calendar.check_constraints.should == true
        end

        it "if total available time is greater than 30" do
          @avail_calendar.check_constraints.should == true
        end

        it "if week day available time is greater than 15" do
          @avail_calendar.check_constraints.should == true
        end
      end

      it "should return false if it is not validate" do
        startTime = Time.now
        endTime = startTime + 6.days
        @obligationEntry = Entry.create!(:user_id => @user1.id, :entry_type => 'obligation', :calendar_id => @avail_calendar.id, :lab_id => @lab1.id, :start_time => startTime, :end_time => endTime)
        @avail_calendar.entries << @obligationEntry
        @avail_calendar.check_constraints.should == false
      end
    end

  end
end
