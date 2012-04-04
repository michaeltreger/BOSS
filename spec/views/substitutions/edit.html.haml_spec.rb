require 'spec_helper'

describe "substitutions/edit" do
  before(:each) do
    @substitution = assign(:substitution, stub_model(Substitution,
      :description => "MyText",
      :message => "MyText"
    ))
  end

  it "renders the edit substitution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => substitutions_path(@substitution), :method => "post" do
      assert_select "textarea#substitution_description", :name => "substitution[description]"
      assert_select "textarea#substitution_message", :name => "substitution[message]"
    end
  end
end
