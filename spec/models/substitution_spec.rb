require 'spec_helper'

describe Substitution do
  before :each do
    @fir_user = User.new(:name => 'Tom')
    @sec_user = User.new(:name => 'Mao')
    @sub = Substitution.create!(:users => [], :entry => Entry.new)
  end
  it "should set substituter successfully" do
    @sub.users << @fir_user
    @sub.users << @sec_user
    @sub.get_from_user.should eq(@fir_user)
    @sub.get_to_user.should eq(@sec_user)
  end
end
