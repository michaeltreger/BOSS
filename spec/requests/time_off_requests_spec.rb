require 'spec_helper'

describe "TimeOffRequests" do
  before (:each) do
    @student = User.create!(:user_type => 1, :name => "John", :approved => true, :initials => "J")
  end
  
  def valid_session
    {:test_user_id => @student.id}
  end

  describe "GET /time_off_requests" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get time_off_requests_path, valid_session
      response.status.should be(200)
    end
  end
end
