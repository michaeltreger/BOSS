require 'spec_helper'

describe "time_off_requests/index" do
  before(:each) do
    assign(:time_off_requests, [
      stub_model(TimeOffRequest,
        :description => "MyText",
        :day_notice => 1
      ),
      stub_model(TimeOffRequest,
        :description => "MyText",
        :day_notice => 1
      )
    ])
  end

  it "renders a list of time_off_requests" do
    #render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => 1.to_s, :count => 2
    pending ""
  end
end
