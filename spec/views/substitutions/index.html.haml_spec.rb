require 'spec_helper'

describe "substitutions/index" do
  before(:each) do
    assign(:substitutions, [
      stub_model(Substitution,
        :description => "MyText",
        :message => "MyText"
      ),
      stub_model(Substitution,
        :description => "MyText",
        :message => "MyText"
      )
    ])
  end

  it "renders a list of substitutions" do
    #render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
    pending ""
  end
end
