require 'spec_helper'

describe UnitsController do
  before (:each) do
    Period.create(:start_date=>Time.now-2.months, :end_date=>Time.now+2.months, :name=>"Period", :visible=>true)
    @admin = User.create!(:name => "John", :activated => true, :initials => "J")
    @user = User.create!(:name => "abcdefg", :activated => true, :initials => "ab")
    group = Group.find_by_name("Administrators")
    group.users << @student
    group.save!
  end
end
