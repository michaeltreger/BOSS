require 'spec_helper'

describe User do
  before :each do
    @period1 = Period.create(:start_date=>Time.now-2.months, :end_date=>Time.now+2.months, :name=>"Period", :visible=>true)
    @period2 = Period.create(:start_date => Time.now + 2.months, :end_date => Time.now + 3.months, :name => "Future", :visible=>true)
    @user1 = User.create!({:name => 'anoriginalname', :activated => true, :initials => "ZZ"})
    @group1 = Group.create!({:name => 'group1', :hour_limit => 10})
    @group2 = Group.create!({:name => 'group2', :hour_limit => 200})
    @group3 = Group.create!({:name => 'group3'})
  end
  describe "user hour limit" do
    it "should be the max of hour limits of all groups the user is in" do
      @group1.users << @user1
      @group1.save!
      @group2.users << @user1
      @group2.save!
      @user1.hour_limit.should == 200
    end
    it "should be 20 if user is in no groups" do
      @user1.hour_limit.should == 20
    end
    it "should take hour limit of 0 if group has no defined hour limit" do
      @group3.users << @user1
      @group3.save!
      @user1.hour_limit.should == 0
    end
  end
  describe "current_preference" do
    it "should return the preference matching the current period" do
      @user1.current_preference(@period1).should == Preference.find(1)
    end
  end
end
