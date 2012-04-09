require 'spec_helper'

describe Substitution do
  before :each do
    @fir_user = User.new(:name => 'Tom')
    @sec_user = User.new(:name => 'Mao')
    @sub = Substitution.create!(:users => [], :entry => Entry.new)
  end
  it "should set substituter successfully" do
    @sub.set_substituter(@fir_user)
    @sub.users[0].should eq(@fir_user)
  end
end
