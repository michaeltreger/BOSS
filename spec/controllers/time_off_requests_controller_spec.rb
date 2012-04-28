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

describe TimeOffRequestsController do

  before(:each) do
    @me = User.create!(:user_type => 1, :name => 'Seven', :activated => 'true', :initials => 'S')
    @my_calendar = Calendar.create!(:calendar_type => 1, :name => 'my_calendar', :user_id => @me.id)
    @my_entry = Entry.create!(:user_id => @me.id, :calendar_id => @my_calendar.id, :start_time => '10:00am', :end_time => '11:00am')
    @now = Time.current()
    session[:test_user_id] = @me.id
  end
  # This should return the minimal set of attributes required to create a valid
  # TimeOffRequest. As you add validations to TimeOffRequest, be sure to
  # update the return value of this method accordingly.

  def valid_attributes
    {
     :user_id => @me.id, :start_time => '2012-04-08T17:30:00Z', :end_time => '2012-04-09T16:30:00Z', :created_at => '2012-04-06T10:30:00Z', :description => 'creating'
    }
  end

   def invalid_attributes
    {
     :user_id => @me.id, :start_time => '2012-04-08T17:30:00Z', :end_time => '2012-04-08T16:30:00Z', :created_at => '2012-04-06T10:30:00Z'
     }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TimeOffRequestsController. Be sure to keep this updated too.
  def valid_session
    {
      :test_user_id => @me.id
    }
  end

  describe "GET index" do
    it "should show all the time-off request I made" do
      @request1 = TimeOffRequest.create! valid_attributes
      @request2 = TimeOffRequest.create!(:user_id => @me.id, :start_time => '2012-04-10T17:30:00Z', :end_time => '2012-04-11T16:30:00Z', :created_at => '2012-04-06T10:30:00Z')
      get :index
      assigns(:time_off_requests).count.should == 2
    end
  end

  #useless
  #describe "GET show" do
    #it "should show the request" do
      #time_off_request = TimeOffRequest.create! valid_attributes
      #get :show, {:id => time_off_request.to_param}, valid_session
      #assigns(:time_off_request).should == time_off_request
    #end
  #end

  describe "GET new" do
    it "should assign a new time_off_request" do
      get :new, {}, valid_session
      assigns(:time_off_request).should be_a_new(TimeOffRequest)
    end
  end

  describe "GET edit" do
    it "should edit the current request" do
      time_off_request = TimeOffRequest.create! valid_attributes
      get :edit, {:id => time_off_request.to_param}, valid_session
      assigns(:time_off_request).should == time_off_request
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new TimeOffRequest" do
        expect {
          post :create, {:time_off_request => valid_attributes}, valid_session
        }.to change(TimeOffRequest, :count).by(1)
      end

      it "should assign a newly created time_off_request as @time_off_request" do
        post :create, {:time_off_request => valid_attributes}, valid_session
        assigns(:time_off_request).should be_a(TimeOffRequest)
        assigns(:time_off_request).should be_persisted
      end

      it "should redirect to the index" do
        post :create, {:time_off_request => valid_attributes}, valid_session
        response.should redirect_to(:action => 'index')
        flash[:notice].should == 'Time off request was successfully created.'
      end
    end

    describe "with invalid params" do
      it "should give a warning" do
        # Trigger the behavior that occurs when invalid params are submitted
        TimeOffRequest.any_instance.stub(:save).and_return(false)
        post :create, {:time_off_request => invalid_attributes}, valid_session
        #assigns(:time_off_request).should_not be_a_new(TimeOffRequest)
        #assert_response :unprocessable_entry
        flash[:error].should == 'Invalid end time'
      end

      it "shoud re-render the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        TimeOffRequest.any_instance.stub(:save).and_return(false)
        post :create, {:time_off_request => invalid_attributes}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "should update the requested time_off_request" do
        time_off_request = TimeOffRequest.create! valid_attributes
        # Assuming there are no other time_off_requests in the database, this
        # specifies that the TimeOffRequest created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        #TimeOffRequest.any_instance.should_receive(:update_attributes).with({'description' => 'updating!'})
        put :update, {:id => time_off_request.to_param, :time_off_request => {:description => 'updating!'}}, valid_session
        time_off_request = TimeOffRequest.find(time_off_request.id)
        time_off_request.description.should == 'updating!'
      end

      it "should assign the requested time_off_request as @time_off_request" do
        time_off_request = TimeOffRequest.create! valid_attributes
        put :update, {:id => time_off_request.to_param, :time_off_request => valid_attributes}, valid_session
        assigns(:time_off_request).should eq(time_off_request)
      end

      it "should redirect to index" do
        time_off_request = TimeOffRequest.create! valid_attributes
        put :update, {:id => time_off_request.to_param, :time_off_request => valid_attributes}, valid_session
        response.should redirect_to(:action => 'index')
      end
    end

    describe "with invalid params" do
      it "assigns the time_off_request as @time_off_request" do
        time_off_request = TimeOffRequest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TimeOffRequest.any_instance.stub(:save).and_return(false)
        put :update, {:id => time_off_request.to_param, :time_off_request => {}}, valid_session
        assigns(:time_off_request).should eq(time_off_request)
      end

      it "re-renders the 'edit' template" do
        time_off_request = TimeOffRequest.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        TimeOffRequest.any_instance.stub(:save).and_return(false)
        put :update, {:id => time_off_request.to_param, :time_off_request => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested time_off_request" do
      time_off_request = TimeOffRequest.create! valid_attributes
      expect {
        delete :destroy, {:id => time_off_request.to_param}, valid_session
      }.to change(TimeOffRequest, :count).by(-1)
    end

    it "redirects to the time_off_requests list" do
      time_off_request = TimeOffRequest.create! valid_attributes
      delete :destroy, {:id => time_off_request.to_param}, valid_session
      response.should redirect_to(time_off_requests_url)
    end
  end

end
