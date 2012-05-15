require 'spec_helper'

describe "time_edits/index" do
  before(:each) do
    Lab.create(:name=>"lab", :initials=>"l", :max_employees=>2, :min_employees=>1)
    User.create!(:name => "Jim", :activated => true, :initials => "J")
    assign(:time_edits, [
      stub_model(TimeEdit,
        :user_id => 1,
        :duration => 2,
        :lab_id => 1,
        :start_time=>Time.now,
        :comment => "Comment"
      ),
      stub_model(TimeEdit,
        :user_id => 1,
        :duration => 2,
        :lab_id => 1,
        :start_time=>Time.now,
        :comment => "Comment"
      )
    ])
  end

  it "renders a list of time_edits" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "J", :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 2.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "l", :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Comment".to_s, :count => 2
  end
end
