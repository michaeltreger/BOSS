require 'spec_helper'

describe "groups/show" do
  before(:each) do
    @group = assign(:group, stub_model(Group,
      :name => "Name",
      :type => 1,
      :hour_limit => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
