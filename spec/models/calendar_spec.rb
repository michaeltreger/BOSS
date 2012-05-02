require 'spec_helper'

describe Calendar do
  before :each do
    @user1 = User.create!({:name => 'anoriginalname', :activated => true, :initials => "ZZ"})
    @user2 = User.create!({:name => 'mockuser', :activated => true, :initials => ":)"})
    @calendar1 = Calendar.create!({:calendar_type => 1, :name => 'reallyimportant', :user_id => @user1.id})
    @calendar2 = Calendar.create!({:calendar_type => 1, :name => 'calendar2', :user_id => @user2.id})
    @lab1 = Lab.create!({:name => 'lab1', :initials => 'l1', :max_employees => 1000, :min_employees => 1})
    @lab2 = Lab.create!({:name => 'lab2', :initials => 'l2', :max_employees => 2000, :min_employees => 1999})
    @originalentry = Entry.create!(:user_id => @user1.id, :calendar_id => @calendar1.id, :lab_id => @lab1.id, :start_time => '8:00am', :end_time => '12:00pm')
    @overlap = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '9:00am', :end_time => '1:00pm' )
    @backtobackdiff = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab2.id, :start_time => '12:00pm', :end_time => '1:00pm')
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
      @calendar1.entries.size.should == 1

      @backtobacksame2.calendar_id = @calendar1.id
      @backtobacksame2.user_id = @calendar1.user_id
      @backtobacksame3.calendar_id = @calendar1.id
      @backtobacksame3.user_id = @calendar1.user_id
      @backtobacksame4.calendar_id = @calendar1.id
      @backtobacksame4.user_id = @calendar1.user_id
      @backtobacksame2.save!
      @backtobacksame3.save!
      @backtobacksame4.save!

      @calendar1.entries = Entry.where(:calendar_id => @calendar1.id)
      @calendar1.entries.size.should == 4
      @calendar1.check_continuity
      @calendar1.entries.size.should == 1
    end
  end
end
