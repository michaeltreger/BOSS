require 'spec_helper'

describe Calendar do
  before :each do
    @user1 = User.create!({:user_type => 1, :name => 'anoriginalname', :activated => true, :initials => "ZZ"})
    @user2 = User.create!({:user_type => 1, :name => 'mockuser', :activated => true, :initials => ":)"})
    @calendar1 = Calendar.create!({:calendar_type => 1, :name => 'reallyimportant', :user_id => @user1.id})
    @calendar2 = Calendar.create!({:calendar_type => 1, :name => 'calendar2', :user_id => @user2.id})
    @lab1 = Lab.create!({:name => 'lab1', :initials => 'l1', :max_employees => 1000, :min_employees => 1})
    @lab2 = Lab.create!({:name => 'lab2', :initials => 'l2', :max_employees => 2000, :min_employees => 1999})
    Entry.create!(:user_id => @user1.id, :calendar_id => @calendar1.id, :lab_id => @lab1.id, :start_time => '8:00am', :end_time => '12:00pm')
    @overlap = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '9:00am', :end_time => '1:00pm' )
    @backtobackdiff = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab2.id, :start_time => '12:00pm', :end_time => '1:00pm')
    @backtobacksame = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :lab_id => @lab1.id, :start_time => '12:00pm', :end_time => '1:00pm')
    @other_entry = Entry.create!(:user_id => @user2.id, :calendar_id => @calendar2.id, :start_time => '2:00pm', :end_time => '4:00pm')
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
end
