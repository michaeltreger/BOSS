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
      @me = User.create!(:user_type => 1, :name => 'Tom', :approved => 'true', :initials => 'T')
      @other = User.create!(:user_type => 1, :name => 'Other', :approved => 'true', :initials => 'O')
      @my_calendar = Calendar.create!(:calendar_type => 1, :name => 'my_calendar', :user_id => @me.id)
      @other_calendar = Calendar.create!(:calendar_type => 1, :name => 'other_calendar', :user_id => @other.id)
      session[:test_user_id] = @me.id
      @my_entry = Entry.create!(:user_id => @me.id, :calendar_id => @my_calendar.id, :start_time => '8:00am', :end_time => '12:00pm')
      @other_entry = Entry.create!(:user_id => @other.id, :calendar_id => @other_calendar.id, :start_time => '2:00pm', :end_time => '4:00pm')
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
      assigns(:available_subs).count.should == 1
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
      get :new, {:current_user => User.create!(:user_type => 1, :name => 'Tom', :approved => 'true', :initials => 'T')}
      assigns(:substitution).should == substitution
    end
    it "should assign current user's calendars' entries to @entries" do
      get :new, {:current_user => User.create!(:user_type => 1, :name => 'Tom', :approved => 'true', :initials => 'T')}
      assigns(:entries).should_not be nil
    end
  end

  describe "GET edit" do
    it "should assign the requested substitution as @substitution" do
      substitution = mock('Substitution')
      Substitution.stub(:find).with('1').and_return(substitution)
      get :edit, {:id => '1'}
      assigns(:substitution).should == substitution
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
      describe "with invlid entry id" do
        it "should redirect to the new substitution path" do
          post :create, {:substitution => {:from_user => @me, :entry => nil, :entry_id => nil}}
          response.should redirect_to new_substitution_path
          flash[:notice].should == 'Please select a shift to substitute.'
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
          post :create, {:substitution => valid_attributes}, :user=> {:id => @other.id}
          Substitution.count.should == 1
          #debugger
          #don't have to_user here.
          Substitution.find(:last).users[1].id.should == @other.id
        end
      end

      it "should redirect to the new substitution path" do
          post :create, {:substitution => valid_attributes}
        response.should redirect_to new_substitution_path
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

  describe "PUT update" do
    describe "with valid params" do
      it "should update the requested substitution" do
        #substitution = mock('Substitution')
        #Substitution.stub(:find).with('1').and_return(substitution)
        substitution = Substitution.create! valid_attributes
        substitution.should_receive(:update_attributes).with({ "description" => 'updating'})
        put :update, {:id => substitution.to_param, :substitution => {:description => 'updating!'}}
        substitution.description.should == 'updating!'
      end

      it "assigns the requested substitution as @substitution" do
        substitution = Substitution.create!(:description => 'haha',:entry =>Entry.new)
        put :update, {:id => substitution.to_param, :substitution => {:description => 'updating'}}
        assigns(:substitution).should == substitution
      end

      it "redirects to the substitution" do
        substitution = Substitution.create! valid_attributes
        put :update, {:id => substitution.to_param, :description => 'udating!'}, valid_session
        assert_response :found
        #flash[:notice].should  == 'Substitution was successfully updated.'
      end
    end

    describe "with invalid params" do
      it "assigns the substitution as @substitution" do
        substitution = Substitution.create!(:description => 'haha',:entry =>Entry.new)
        # Trigger the behavior that occurs when invalid params are submitted
        Substitution.stub(:save).and_return(false)
        put :update, {:id => substitution.to_param, :substitution => {:description => 'haha',:entry =>Entry.new}}
        assigns(:substitution).should eq(substitution)
      end

      it "re-renders the 'edit' template" do
        Substitution.create!(:description => 'haha',:entry =>Entry.new)
        # Trigger the behavior that occurs when invalid params are submitted
        Substitution.any_instance.stub(:save).and_return(false)
        put :update, {:id => '1', :substitution => {:description => 'haha',:entry =>Entry.new}}
        response.should render_template("edit")
      end
    end
  end

  describe "Take or Assign Sub" do
    before do
      @substitution = Substitution.create!(:description => 'haha', :user_id => @other.id, :entry => @other_entry, :entry_id => @other_entry.id)
    end
    describe "for available time" do
      it "would take sub successfully" do
        put :take_or_assign_subs, :calendar => {:id => @my_calendar.id}, :entries => {@substitution.id => "1"}
        changedEntry = Entry.find(@substitution.entry_id)
        changedEntry.calendar_id.should == @my_calendar.id
        #debugger
        changedEntry.user_id.should == @me.id
      end
    end
    describe "for not-available time" do
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @substitution = Substitution.create!(:description => 'haha',:entry =>Entry.new)
    end
    it "should perform destroy substitution action" do
      Substitution.should_receive(:find).with('1').and_return @substitution
      @substitution.should_receive(:destroy)
      delete :destroy, {:id => '1'}
    end
    it "should destroy substitution sucessfully" do
      delete :destroy, {:id => '1'}
      Substitution.count.should == 0
    end
    it "redirects to the substitutions list" do
      delete :destroy, {:id => '1'}
      response.should redirect_to substitutions_url
    end
  end

end
