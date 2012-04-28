require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :user_type => 1,
      :name => "MyString",
      :email => "MyString",
      :cas_user => 1,
      :phone => "MyString",
      :initials => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path(@user), :method => "post" do
      #assert_select "input#user_user_type", :name => "user[user_type]"
      assert_select "input#user_name", :name => "user[name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_cas_user", :name => "user[cas_user]"
      assert_select "input#user_phone", :name => "user[phone]"
      assert_select "input#user_initials", :name => "user[initials]"
    end
  end
end
