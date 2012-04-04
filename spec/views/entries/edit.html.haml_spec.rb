require 'spec_helper'

describe "entries/edit" do
  before(:each) do
    @entry = assign(:entry, stub_model(Entry,
      :description => "MyText",
      :repeating => false,
      :finalized => false
    ))
  end

  it "renders the edit entry form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => entries_path(@entry), :method => "post" do
      assert_select "textarea#entry_description", :name => "entry[description]"
      assert_select "input#entry_repeating", :name => "entry[repeating]"
      assert_select "input#entry_finalized", :name => "entry[finalized]"
    end
  end
end
