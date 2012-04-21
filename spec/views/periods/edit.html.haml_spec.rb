require 'spec_helper'

describe "periods/edit" do
  before(:each) do
    @period = assign(:period, stub_model(Period,
      :name => "MyString",
      :visible => false,
      :exception => false,
      :type => 1
    ))
  end

  it "renders the edit period form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => periods_path(@period), :method => "post" do
      assert_select "input#period_name", :name => "period[name]"
      assert_select "input#period_visible", :name => "period[visible]"
      assert_select "input#period_exception", :name => "period[exception]"
      assert_select "input#period_type", :name => "period[type]"
    end
  end
end
