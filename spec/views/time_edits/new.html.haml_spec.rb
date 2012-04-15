require 'spec_helper'

describe "time_edits/new" do
  before(:each) do
    assign(:time_edit, stub_model(TimeEdit,
      :user_id => 1,
      :duration => 1,
      :lab_id => 1,
      :comment => "MyString"
    ).as_new_record)
  end

  it "renders new time_edit form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => time_edits_path, :method => "post" do
      assert_select "input#time_edit_user_id", :name => "time_edit[user_id]"
      assert_select "input#time_edit_duration", :name => "time_edit[duration]"
      assert_select "input#time_edit_lab_id", :name => "time_edit[lab_id]"
      assert_select "input#time_edit_comment", :name => "time_edit[comment]"
    end
  end
end
