require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe SubstitutionsController do

  before(:each) do
    @period = Period.create(:start_date=>Time.now-2.months, :end_date=>Time.now+2.months, :name=>"Period", :visible=>true)
    @my_group = Group.create!(:group_type => 1, :name => 'undergrad', :hour_limit => 20, :description => 'cs169')
    #@my_group_user = Group_user.create!(:group_id => @my_group.id, :user_id => @me.id, :created_at => '2012-01-01T00:00:00Z')
    @me = User.create!(:name => 'Tom', :activated => 'true', :initials => 'T', :cas_user => 123)
    @other = User.create!(:name => 'Other', :activated => 'true', :initials => 'O', :cas_user => 456)
    @my_calendar = @me.shift_calendar
    @other_calendar = @other.shift_calendar
    session[:test_user_id] = @me.id
    @my_entry = Entry.create!(:user_id => @me.id, :calendar_id => @my_calendar.id, :start_time => Time.now+2.days, :end_time => Time.now+2.days+4.hour)
    @other_entry = Entry.create!(:user_id => @other.id, :calendar_id => @other_calendar.id, :start_time => Time.now+3.days, :end_time => Time.now+3.days+2.hours)
    @too_long_entry = Entry.create!(:user_id => @other.id, :calendar_id => @other_calendar.id, :start_time => Time.now+4.days, :end_time => Time.now+4.days+23.hours)
    group = Group.find_by_name("Administrators")
    group.users << @me
    group.users << @other
    group.save!
  end
  def valid_attributes
    {
      :description => 'creating', :user_id => @me.id,  :entry => @my_entry, :entry_id => @my_entry.id
    }
  end

  def valid_session
    {
      :test_user_id => @me.id
    }
  end

  describe "GET index" do
    it "should group subtitutions into categories for display" do
      mySub = Substitution.create(:description => 'mySub', :entry => Entry.new)
      mySub.users << @me
      mySub.save!
      reservedSub = Substitution.create(:description => 'reservedSub', :entry => Entry.new)
      reservedSub.users << @other
      reservedSub.users << @me
      reservedSub.save!
      availableSub = Substitution.create(:description => 'availableSub', :entry => Entry.new)
      availableSub.users << @other
      availableSub.save!

      get :index
      assigns(:substitutions).count.should == 3
      assigns(:my_subs).count.should == 1
      assigns(:reserved_subs).count.should == 1
      assigns(:a_subs).count.should == 1
    end
    it "should render to index page" do
      get :index
      response.should render_template('index')
    end
  end

  describe "GET new" do
    it "should assign a new substitution as @substitution" do
      substitution = mock('Substitution')
      Substitution.stub(:new).and_return(substitution)
      get :new
      assigns(:substitution).should == substitution
    end
    it "should assign current user's calendars' entries to @entries" do
      get :new
      assigns(:entries).should_not be nil
    end
  end

  describe "POST create" do
    before (:each) do
      def valid_attributes
        {
          :from_user => @me, :entry => @my_entry, :entry_id => @my_entry.id, :description => 'creating'
        }
      end
    end
    describe "with valid params" do
      describe "with invlid entry or partial shift" do
        it "should redirect to new substitution path" do
          post :create, {:substitution => {:from_user => @me, :entry => nil, :entry_id => nil}, :partial_shift => nil}
          response.should redirect_to new_substitution_path
          flash[:error].should == 'Please select a shift to substitute.'
        end
      end

      describe "with no reserved employee" do
        it "should create a new normal substitution" do
          post :create, {:substitution => valid_attributes}, valid_session
          Substitution.count.should == 1
        end
      end
      describe "with a reserved employee" do
        it "should create a new reserve substitution" do
          post :create, {:substitution => valid_attributes, :user=> {:id => @other.id}}
          Substitution.count.should == 1
          Substitution.find(:last).users[1].id.should == @other.id
        end
      end

      it "should redirect to the substitution path" do
        post :create, {:substitution => valid_attributes}
        response.should redirect_to substitutions_path
        flash[:notice].should == 'Substitution was successfully created.'
      end
    end

    describe "with invalid params" do
      it "should redirect to the new substitution path" do
        # Trigger the behavior that occurs when invalid params are submitted
        Substitution.any_instance.stub(:save).and_return(false)
          post :create, :substitution => valid_attributes
        response.should redirect_to new_substitution_path
        flash[:notice].should == 'Substitution could not be created.'
      end
    end
  end

  describe "Take or Assign Sub" do
    before (:each) do
      @substitution = Substitution.create!(:description => 'haha', :user_id => @other.id, :entry => @other_entry, :entry_id => @other_entry.id)
    end
    describe "for available time" do
      describe "while not exceeding hour limit" do
        it "should take sub successfully" do
          request.env["HTTP_REFERER"] = substitutions_url
          put :take_or_assign_subs, :target_user => {:id => @me.id}, :entries => {@substitution.id => "1"}
          changedEntry = Entry.find(@substitution.entry_id)
          changedEntry.calendar_id.should == @my_calendar.id
          #debugger
          #An entry doesn't have to belong to me directly, so it doesn't matter
          #changedEntry.user_id.should == @me.id
        end
      end
      describe "While exceeding hour limit" do
        it "should not take sub" do
          request.env["HTTP_REFERER"] = substitutions_url
          @long_substitution = Substitution.create!(:description => 'I\'m long', :entry => @too_long_entry, :entry_id => @too_long_entry.id)
          put :take_or_assign_subs, :target_user => {:id => @me.id}, :entries => {@long_substitution.id => "1"}
          flash[:error].should include('The following subs could not be taken')
        end
        it "should redirect to index" do
          request.env["HTTP_REFERER"] = substitutions_url
          @long_substitution = Substitution.create!(:description => 'I\'m long', :entry => @too_long_entry, :entry_id => @too_long_entry.id)
          put :take_or_assign_subs, :target_user => {:id => @me.id}, :entries => {@long_substitution.id => "1"}
          response.should redirect_to substitutions_url
        end
      end
    end
  end
  describe "for not-available time" do
  end

  describe "DELETE destroy" do
    before(:each) do
      @substitution = Substitution.create!(:description => 'haha',:entry =>Entry.new)
    end
    it "should perform destroy substitution action" do
      Substitution.should_receive(:find).with('1').and_return @substitution
      @substitution.should_receive(:destroy)
      delete :destroy, {:id => 1}
    end
    it "should destroy substitution sucessfully" do
      delete :destroy, {:id => 1}
      Substitution.count.should == 0
    end
    it "should redirect to the substitutions index" do
      delete :destroy, {:id => 1}
      response.should redirect_to substitutions_url
    end
  end

end
