require 'spec_helper'

describe "labs/index" do
  before(:each) do
    assign(:labs, [
      stub_model(Lab,
        :description => "MyText",
        :name => "Name",
        :initials => "Initials",
        :max_employees => 1,
        :min_employees => 1
      ),
      stub_model(Lab,
        :description => "MyText",
        :name => "Name",
        :initials => "Initials",
        :max_employees => 1,
        :min_employees => 1
      )
    ])
  end

  it "renders a list of labs" do
    #render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "Initials".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => 1.to_s, :count => 2
    pending ""
  end
end
