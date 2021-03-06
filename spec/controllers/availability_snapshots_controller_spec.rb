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

describe AvailabilitySnapshotsController do

  before (:each) do
    @period = Period.create(:start_date=>Time.current-2.months, :end_date=>Time.current+2.months, :name=>"Period", :visible=>true)
    @admin = User.create!(:name => "John", :activated => true, :initials => "J")
    @admin.availability_calendar(@period).entries << Entry.create(:entry_type => "rather_not", :start_time => (Time.current).change(:min=>0), :end_time =>(Time.current+2.hours).change(:min=>0))
    @admin.availability_calendar(@period).entries << Entry.create(:entry_type => "prefer", :start_time => (Time.current+4.hours).change(:min=>0), :end_time =>(Time.current+6.hours).change(:min=>0))
    @admin.availability_calendar(@period).entries << Entry.create(:entry_type => "rather_not", :start_time => (Time.current+7.hours).change(:min=>0), :end_time =>(Time.current+8.hours).change(:min=>0))
    @admin.availability_calendar(@period).entries << Entry.create(:entry_type => "prefer", :start_time => (Time.current+10.hours).change(:min=>0), :end_time =>(Time.current+12.hours).change(:min=>0))
    @admin.save
    group = Group.find_by_name("Administrators")
    group.users << @admin
    group.save!
  end

  # This should return the minimal set of attributes required to create a valid
  # AvailabilitySnapshot. As you add validations to AvailabilitySnapshot, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    time = Time.current
    {:start_date =>time-2.days, :end_date =>time+2.days, :availabilities=>{:avail=>{time=>["J"]},:rather_not=>{time=>["J"]},:prefer=>{time=>["J"]}}}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AvailabilitySnapshotsController. Be sure to keep this updated too.
  def valid_session
    {:test_user_id => @admin.id}
  end

  describe "GET index" do
    it "assigns all availability_snapshots as @availability_snapshots" do
      availability_snapshot = AvailabilitySnapshot.create! valid_attributes
      get :index, {}, valid_session
      assigns(:availability_snapshots).should eq([availability_snapshot])
    end
  end

  describe "GET show" do
    it "assigns the requested availability_snapshot as @availability_snapshot" do
      availability_snapshot = AvailabilitySnapshot.create! valid_attributes
      get :show, {:id => availability_snapshot.to_param}, valid_session
      assigns(:availability_snapshot).should eq(availability_snapshot)
    end
  end

  describe "GET new" do
    it "assigns a new availability_snapshot as @availability_snapshot" do
      get :new, {}, valid_session
      assigns(:availability_snapshot).should be_a_new(AvailabilitySnapshot)
    end
  end

  describe "GET edit" do
    it "assigns the requested availability_snapshot as @availability_snapshot" do
      availability_snapshot = AvailabilitySnapshot.create! valid_attributes
      get :edit, {:id => availability_snapshot.to_param}, valid_session
      assigns(:availability_snapshot).should eq(availability_snapshot)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AvailabilitySnapshot" do
        expect {
          post :create, {:availability_snapshot => valid_attributes}, valid_session
        }.to change(AvailabilitySnapshot, :count).by(1)
      end

      it "assigns a newly created availability_snapshot as @availability_snapshot" do
        post :create, {:availability_snapshot => valid_attributes}, valid_session
        assigns(:availability_snapshot).should be_a(AvailabilitySnapshot)
        assigns(:availability_snapshot).should be_persisted
      end

      it "redirects to the created availability_snapshot" do
        post :create, {:availability_snapshot => valid_attributes}, valid_session
        response.should redirect_to(AvailabilitySnapshot.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved availability_snapshot as @availability_snapshot" do
        # Trigger the behavior that occurs when invalid params are submitted
        AvailabilitySnapshot.any_instance.stub(:save).and_return(false)
        post :create, {:availability_snapshot => {}}, valid_session
        assigns(:availability_snapshot).should be_a_new(AvailabilitySnapshot)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AvailabilitySnapshot.any_instance.stub(:save).and_return(false)
        post :create, {:availability_snapshot => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested availability_snapshot" do
        availability_snapshot = AvailabilitySnapshot.create! valid_attributes
        # Assuming there are no other availability_snapshots in the database, this
        # specifies that the AvailabilitySnapshot created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AvailabilitySnapshot.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => availability_snapshot.to_param, :availability_snapshot => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested availability_snapshot as @availability_snapshot" do
        availability_snapshot = AvailabilitySnapshot.create! valid_attributes
        put :update, {:id => availability_snapshot.to_param, :availability_snapshot => valid_attributes}, valid_session
        assigns(:availability_snapshot).should eq(availability_snapshot)
      end

      it "redirects to the availability_snapshot" do
        availability_snapshot = AvailabilitySnapshot.create! valid_attributes
        put :update, {:id => availability_snapshot.to_param, :availability_snapshot => valid_attributes}, valid_session
        response.should redirect_to(availability_snapshot)
      end
    end

    describe "with invalid params" do
      it "assigns the availability_snapshot as @availability_snapshot" do
        availability_snapshot = AvailabilitySnapshot.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AvailabilitySnapshot.any_instance.stub(:save).and_return(false)
        put :update, {:id => availability_snapshot.to_param, :availability_snapshot => {}}, valid_session
        assigns(:availability_snapshot).should eq(availability_snapshot)
      end

      it "re-renders the 'edit' template" do
        availability_snapshot = AvailabilitySnapshot.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AvailabilitySnapshot.any_instance.stub(:save).and_return(false)
        put :update, {:id => availability_snapshot.to_param, :availability_snapshot => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested availability_snapshot" do
      availability_snapshot = AvailabilitySnapshot.create! valid_attributes
      expect {
        delete :destroy, {:id => availability_snapshot.to_param}, valid_session
      }.to change(AvailabilitySnapshot, :count).by(-1)
    end

    it "redirects to the availability_snapshots list" do
      availability_snapshot = AvailabilitySnapshot.create! valid_attributes
      delete :destroy, {:id => availability_snapshot.to_param}, valid_session
      response.should redirect_to(availability_snapshots_url)
    end
  end

end
