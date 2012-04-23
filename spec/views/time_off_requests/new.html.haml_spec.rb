require 'spec_helper'

describe "time_off_requests/new" do
  before(:each) do
    assign(:time_off_request, stub_model(TimeOffRequest,
      :description => "MyText",
      :day_notice => 1
    ).as_new_record)
  end

  it "renders new time_off_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => time_off_requests_path, :method => "post" do
      assert_select "textarea#time_off_request_description", :name => "time_off_request[description]"
    end
  end
end
