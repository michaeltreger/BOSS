require 'spec_helper'

describe "preferences/show" do
  before(:each) do
    @preference = assign(:preference, stub_model(Preference,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Dispersal/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Timeof Week/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Timeof Day/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
