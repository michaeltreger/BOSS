require 'spec_helper'

describe "calendars/new" do
  before(:each) do
    assign(:calendar, stub_model(Calendar,
      :type => 1,
      :name => "MyString",
      :description => "MyText"
    ).as_new_record)
  end

  it "renders new calendar form" do
   # render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "form", :action => calendars_path, :method => "post" do
     # assert_select "input#calendar_type", :name => "calendar[type]"
      #assert_select "input#calendar_name", :name => "calendar[name]"
      #assert_select "textarea#calendar_description", :name => "calendar[description]"
    #end
    pending ""
  end
end
