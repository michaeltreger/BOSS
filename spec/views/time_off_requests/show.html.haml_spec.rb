require 'spec_helper'

describe "time_off_requests/show" do
  before(:each) do
    @time_off_request = assign(:time_off_request, stub_model(TimeOffRequest,
      :description => "MyText",
      :day_notice => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
