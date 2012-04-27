require 'spec_helper'

describe "preferences/index" do
  before(:each) do
    @student1 = User.create!(:user_type => 1, :name => "John", :activated => true, :initials => "J")
    @student2 = User.create!(:user_type => 1, :name => "John", :activated => true, :initials => "J")
    @period = Period.create!()
    assign(:preferences, [
      stub_model(Preference,
        :user_id => @student1.id,
        :period_id => @period.id,
        :hours_min => 20,
        :hours_max => 30,
        :hours_pref => 40,
        :hours_day => 50,
        :dispersal => "Dispersal",
        :timeof_week => "Timeof Week",
        :timeof_day => "Timeof Day",
        :other => "a"
      ),
      stub_model(Preference,
        :user_id => @student1.id,
        :period_id => @period.id,
        :hours_min => 20,
        :hours_max => 30,
        :hours_pref => 40,
        :hours_day => 50,
        :dispersal => "Dispersal",
        :timeof_week => "Timeof Week",
        :timeof_day => "Timeof Day",
        :other => "a"
      )
    ])
  end

  it "renders a list of preferences" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 20.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 30.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 40.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 50.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Dispersal".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Timeof Week".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Timeof Day".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "a".to_s, :count => 2
  end
end
