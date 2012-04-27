require 'spec_helper'

describe Period do
  it "should find the current period" do
    p1 = Period.create(:start_date=>Time.now-10.days, :end_date=>Time.now+10.days, :name=>"Period 1", :visible=>true)
    Period.current.should == p1
  end
  
  it "should find the the priority period" do
    p1 = Period.create(:start_date=>Time.now-10.days, :end_date=>Time.now+10.days, :name=>"Period 1", :visible=>true)
    p2 = Period.create(:start_date=>Time.now-2.days, :end_date=>Time.now+2.days, :name=>"Period 2", :visible=>true, :exception=>true)
    Period.current.should == p2
  end
end
