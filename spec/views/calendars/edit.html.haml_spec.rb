require 'spec_helper'

describe "calendars/edit" do
  before(:each) do
    @calendar = assign(:calendar, stub_model(Calendar,
      :type => 1,
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit calendar form" do
   # render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "form", :action => calendars_path(@calendar), :method => "post" do
     # assert_select "input#calendar_type", :name => "calendar[type]"
      #assert_select "input#calendar_name", :name => "calendar[name]"
      #assert_select "textarea#calendar_description", :name => "calendar[description]"
   pending ""
  end
end
