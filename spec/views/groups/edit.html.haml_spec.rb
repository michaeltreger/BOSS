require 'spec_helper'

describe "groups/edit" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :name => "MyString",
      :group_type => 1,
      :hour_limit => 1
    ))
  end

  it "renders the edit group form" do
    #render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "form", :action => groups_path(@group), :method => "post" do
    #assert_select "input#group_name", :name => "group[name]"
    #assert_select "input#group_type", :name => "group[type]"
    #assert_select "input#group_hour_limit", :name => "group[hour_limit]"
  end
end
