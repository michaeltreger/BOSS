require 'spec_helper'

describe "labs/edit" do
  before(:each) do
    @lab = assign(:lab, stub_model(Lab,
      :description => "MyText",
      :name => "MyString",
      :initials => "MyString",
      :max_employees => 1,
      :min_employees => 1
    ))
  end

  it "renders the edit lab form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => labs_path(@lab), :method => "post" do
      assert_select "textarea#lab_description", :name => "lab[description]"
      assert_select "input#lab_name", :name => "lab[name]"
      assert_select "input#lab_initials", :name => "lab[initials]"
      assert_select "input#lab_max_employees", :name => "lab[max_employees]"
      assert_select "input#lab_min_employees", :name => "lab[min_employees]"
    end
  end
end
