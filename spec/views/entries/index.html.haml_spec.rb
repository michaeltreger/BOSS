require 'spec_helper'

describe "entries/index" do
  before(:each) do
    assign(:entries, [
      stub_model(Entry,
        :description => "MyText",
        :repeating => false,
        :finalized => false
      ),
      stub_model(Entry,
        :description => "MyText",
        :repeating => false,
        :finalized => false
      )
    ])
  end

  it "renders a list of entries" do
    #render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => false.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #assert_select "tr>td", :text => false.to_s, :count => 2
    pending ""
  end
end
