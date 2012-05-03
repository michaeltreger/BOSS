require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the TimeOffRequestsHelper. For example:
#
# describe TimeOffRequestsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe TimeOffRequestsHelper do
  before (:each) do
    @old = TimeOffRequest.create!(:start_time => Time.now - 5.day, :end_time => Time.now - 1.day)
    @new = TimeOffRequest.create!(:start_time => Time.now + 5.day, :end_time => Time.now + 10.day)
  end
  describe "recycle" do
    it "should delete passed time off requests" do
      recycle
      TimeOffRequest.find_by_id(@old.id).should == nil
      TimeOffRequest.find_by_id(@new.id).should == @new
    end
  end
end
