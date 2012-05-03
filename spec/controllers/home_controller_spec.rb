require 'spec_helper'

describe HomeController do
  before (:each) do
    @me = User.create(:name=>"Michael", :cas_user=>720656, :initials=>"MT", :email=>"michael.treger@gmail.com", :activated => true)
    session[:cas_user_id] = @me.id
  end
  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

end
