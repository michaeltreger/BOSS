require 'spec_helper'

describe HomeController do
  before (:each) do
    Period.create(:start_date=>Time.now-2.months, :end_date=>Time.now+2.months, :name=>"Period", :visible=>true)
    @admin = User.create!(:name => "John", :activated => true, :initials => "J")
    group = Group.find_by_name("Administrators")
    group.users << @admin
    group.save!

  end
  describe "GET 'index'" do
    it "returns http success" do
      visit('/')
      response.should render_template('index')
    end
  end

end
