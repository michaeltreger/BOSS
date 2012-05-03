require 'spec_helper'

describe "labs/show" do
  before(:each) do
    @lab = assign(:lab, stub_model(Lab,
      :description => "MyText",
      :name => "Name",
      :initials => "Initials",
      :max_employees => 1,
      :min_employees => 1
    ))
    @units = @lab.groups
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Initials/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
