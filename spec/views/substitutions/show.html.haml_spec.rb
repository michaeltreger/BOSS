require 'spec_helper'

describe "substitutions/show" do
  before(:each) do
    @substitution = assign(:substitution, stub_model(Substitution,
      :description => "MyText",
      :message => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
