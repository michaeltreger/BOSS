require 'spec_helper'

describe "periods/new" do
  before(:each) do
    assign(:period, stub_model(Period,
      :name => "MyString",
      :visible => false,
      :exception => false,
      :type => 1
    ).as_new_record)
  end

  it "renders new period form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => periods_path, :method => "post" do
      assert_select "input#period_name", :name => "period[name]"
      assert_select "input#period_visible", :name => "period[visible]"
      assert_select "input#period_exception", :name => "period[exception]"
      assert_select "input#period_type", :name => "period[type]"
    end
  end
end
