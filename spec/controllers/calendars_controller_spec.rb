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

describe CalendarsController do

  before (:each) do
    @student = User.create!(:user_type => 1, :name => "John", :approved => true, :initials => "J")
    session[:test_user_id] = 1
  end
  # This should return the minimal set of attributes required to create a valid
  # Calendar. As you add validations to Calendar, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
      :calendar_type => 1, :name =>'testing'
    }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CalendarsController. Be sure to keep this updated too.
  def valid_session
    {
      :test_user_id => 1
    }
  end

  describe "GET index" do
    it "assigns all calendars as @calendars" do
      calendars = Calendar.all
      calendars.each do |calendar|
        calendar.user_id.should == 1
      end
    end
  end

  describe "GET show" do
    it "assigns the requested calendar as @calendar" do
      calendar = Calendar.create! valid_attributes
      get :show, {:id => calendar.id}, valid_session
      assigns(:calendar).should eq(calendar)
    end
  end

  describe "GET new" do
    it "assigns a new calendar as @calendar" do
      get :new, {}, valid_session
      assigns(:calendar).should be_a_new(Calendar)
    end
  end

  describe

  describe "GET edit" do
    it "assigns the requested calendar as @calendar" do
      calendar = Calendar.create! valid_attributes
      get :edit, {:id => calendar.to_param}, valid_session
      assigns(:calendar).should eq(calendar)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Calendar" do
        expect {
          post :create, {:calendar => valid_attributes}, valid_session
        }.to change(Calendar, :count).by(1)
      end

      it "assigns a newly created calendar as @calendar" do
        post :create, {:calendar => valid_attributes}, valid_session
        assigns(:calendar).should be_a(Calendar)
        assigns(:calendar).should be_persisted
      end

      it "redirects to the created calendar" do
        post :create, {:calendar => valid_attributes}, valid_session
        response.should redirect_to(Calendar.last)
      end
    end

  describe "with invalid params" do
      it "assigns a newly created but unsaved calendar as @calendar" do
        # Trigger the behavior that occurs when invalid params are submitted
        Calendar.any_instance.stub(:save).and_return(false)
        post :create, {:calendar => {}}, valid_session
        assigns(:calendar).should be_a_new(Calendar)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Calendar.any_instance.stub(:save).and_return(false)
        post :create, {:calendar => {}}, valid_session
        response.should render_template("new")
      end
    end
  end



  describe "PUT update" do
    describe "with valid params" do
      before do

        @calendar = Calendar.create!(:calendar_type => 1, :name => "testing11", :description => "student1 clendar1", :user_id => @student.id)

      end
      it "updates the requested calendar" do
        # Assuming there are no other calendars in the database, this
        # specifies that the Calendar created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        entries0 = [{"description" => "", "end_time" => "2012-04-08T18:00:00Z","entry_type" => "prefer", "start_time" => "2012-04-08T17:30:00Z"}, {"description" => "", "end_time" => "2012-04-09T21:00:00Z","entry_type" => "prefer", "start_time" => "2012-04-09T20:00:00Z"}]
        @calendar.update_calendar(entries0)
        @calendar.entries[0].start_time.should == "Sun, 08 Apr 2012 17:30:00 UTC +00:00"
        @calendar.entries[1].end_time.should == "Mon, 09 Apr 2012 21:00:00 UTC +00:00"
      end

      it "assigns the requested calendar as @calendar" do
        calendar = Calendar.create! valid_attributes
        put :update, {:id => calendar.to_param, :calendar => valid_attributes}, valid_session
        assigns(:calendar).should eq(calendar)
      end

      it "redirects to the calendar" do
        calendar = Calendar.create! valid_attributes
        put :update, {:id => calendar.to_param, :calendar => valid_attributes}, valid_session
        response.should redirect_to(calendar)
      end
    end

    describe "with invalid params" do
      it "assigns the calendar as @calendar" do
        calendar = Calendar.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Calendar.any_instance.stub(:save).and_return(false)
        put :update, {:id => calendar.to_param, :calendar => {}}, valid_session
        assigns(:calendar).should eq(calendar)
      end

      it "re-renders the 'edit' template" do
        calendar = Calendar.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Calendar.any_instance.stub(:save).and_return(false)
        put :update, {:id => calendar.to_param, :calendar => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested calendar" do
      calendar = Calendar.create! valid_attributes
      expect {
        delete :destroy, {:id => calendar.to_param}, valid_session
      }.to change(Calendar, :count).by(-1)
    end

    it "redirects to the calendars list" do
      calendar = Calendar.create! valid_attributes
      delete :destroy, {:id => calendar.to_param}, valid_session
      response.should redirect_to(calendars_url)
    end
  end

  describe "admin/nonadmin viewing calendars" do
    before (:each) do
      @student1 = User.create!(:type => 1, :name => "Micky", :cas_user => 123123)
      @student2 = User.create!(:type => 1, :name => "Minnie", :cas_user => 456456)
      @calendar11  = Calendar.create!(:calendar_type => 1, :name => "testing11", :description => "student1 clendar1", :user_id => @student1.id)
      @calendar12  = Calendar.create!(:calendar_type => 1, :name => "testing12", :description => "student1 caldendar2", :user_id => @student1.id)
      @calendar21  = Calendar.create!(:calendar_type => 1, :name => "testing21", :description => "student2 caldendar1", :user_id => @student2.id)
      @calendar22  = Calendar.create!(:calendar_type => 1, :name => "testing22", :description => "student2 caldendar2", :user_id => @student2.id)
      @admin = User.create!(:type => 0, :name => "AF", :cas_user => 000000)
    end
    describe "admin logged in" do
      before (:each) do
        session[:test_user_id] = @admin.id
      end

      it "admin can view all students' calendars" do
        calendars = Calendar.all
        calendars[0].id.should == @calendar11.id
        calendars[1].should == @calendar12
        calendars[2].should == @calendar21
        calendars[3].should == @calendar22
      end
    end
    describe "nonadmin logged in" do
      before (:each) do
        session[:test_user_id] = @student1.id
      end
      it "can't view other students' calendar" do
        calendars = Calendar.where(:user_id => @student1.id)
        calendars.each do |calendar|
          calendar.id.should_not == @calendar21.id && calendar.should_not == @calendar22
        end
      end
    end

  end

end
