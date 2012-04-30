require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = User.create!(
      :activated => true,
      :user_type => 1,
      :name => "Name",
      :email => "Email",
      :cas_user => 1,
      :initials => "Initials"
    )
    @current_user = @user
    @groups = []
    session[:test_user_id] = @user.id
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Initials/)
  end
end
