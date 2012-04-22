require 'spec_helper'

describe "Preferences" do
  before(:each) do
      @user = User.create!(:user_type => 1, :name => 'Tom', :approved => 'true', :initials => 'T')
      @calendar = Calendar.create!(:user_id => @user.id, :name => "#{@user.name}'s calendar",:calendar_type => 1)
  end

  # This should return the minimal set of attributes required to create a valid
  # Preference. As you add validations to Preference, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PreferencesController. Be sure to keep this updated too.
  def valid_session
    {:test_user_id => @user.id}
  end
  
  describe "GET /preferences" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get preferences_path, valid_session
      response.status.should be(200)
    end
  end
end
