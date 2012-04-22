require 'spec_helper'

describe "preferences/index" do
  before(:each) do
    assign(:preferences, [
      stub_model(Preference,
        :user_id => 1,
        :period_id => 1,
        :hours_min => 1,
        :hours_max => 1,
        :hours_pref => 1,
        :hours_day => 1,
        :dispersal => "Dispersal",
        :timeof_week => "Timeof Week",
        :timeof_day => "Timeof Day",
        :other => ""
      ),
      stub_model(Preference,
        :user_id => 1,
        :period_id => 1,
        :hours_min => 1,
        :hours_max => 1,
        :hours_pref => 1,
        :hours_day => 1,
        :dispersal => "Dispersal",
        :timeof_week => "Timeof Week",
        :timeof_day => "Timeof Day",
        :other => ""
      )
    ])
  end

  it "renders a list of preferences" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Dispersal".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Timeof Week".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Timeof Day".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
