require 'spec_helper'

describe "substitutions/new" do
  before(:each) do
    assign(:substitution, stub_model(Substitution,
      :description => "MyText",
      :message => "MyText"
    ).as_new_record)
  end

  it "renders new substitution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => substitutions_path, :method => "post" do
      assert_select "textarea#substitution_description", :name => "substitution[description]"
      assert_select "textarea#substitution_message", :name => "substitution[message]"
    end
  end
end
