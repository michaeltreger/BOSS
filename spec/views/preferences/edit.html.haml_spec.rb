require 'spec_helper'

describe "preferences/edit" do
  before(:each) do
    @preference = assign(:preference, stub_model(Preference,
      :user_id => 1,
      :period_id => 1,
      :hours_min => 1,
      :hours_max => 1,
      :hours_pref => 1,
      :hours_day => 1,
      :dispersal => "MyString",
      :timeof_week => "MyString",
      :timeof_day => "MyString",
      :other => ""
    ))
  end

  it "renders the edit preference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => preferences_path(@preference), :method => "post" do
      assert_select "input#preference_user_id", :name => "preference[user_id]"
      assert_select "input#preference_period_id", :name => "preference[period_id]"
      assert_select "input#preference_hours_min", :name => "preference[hours_min]"
      assert_select "input#preference_hours_max", :name => "preference[hours_max]"
      assert_select "input#preference_hours_pref", :name => "preference[hours_pref]"
      assert_select "input#preference_hours_day", :name => "preference[hours_day]"
      assert_select "input#preference_dispersal", :name => "preference[dispersal]"
      assert_select "input#preference_timeof_week", :name => "preference[timeof_week]"
      assert_select "input#preference_timeof_day", :name => "preference[timeof_day]"
      assert_select "input#preference_other", :name => "preference[other]"
    end
  end
end
