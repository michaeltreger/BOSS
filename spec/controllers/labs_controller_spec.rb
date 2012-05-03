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

describe LabsController do
  before (:each) do
    Period.create(:start_date=>Time.now-2.months, :end_date=>Time.now+2.months, :name=>"Period", :visible=>true)
    @admin = User.create!(:name => "John", :activated => true, :initials => "J")
    group = Group.find_by_name("Administrators")
    group.users << @admin
    group.save!
  end

  # This should return the minimal set of attributes required to create a valid
  # Lab. As you add validations to Lab, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:name=>"Moffit", :initials=>"MMF", :max_employees=>4, :min_employees=>1}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LabsController. Be sure to keep this updated too.
  def valid_session
    {:test_user_id => @admin.id}
  end

  describe "GET index" do
    it "assigns all labs as @labs" do
      lab = Lab.create! valid_attributes
      get :index, {}, valid_session
      assigns(:labs).should eq([lab])
    end
  end

  describe "GET show" do
    it "assigns the requested lab as @lab" do
      lab = Lab.create! valid_attributes
      get :show, {:id => lab.to_param}, valid_session
      assigns(:lab).should eq(lab)
    end
  end

  describe "GET new" do
    it "assigns a new lab as @lab" do
      get :new, {}, valid_session
      assigns(:lab).should be_a_new(Lab)
    end
  end

  describe "GET edit" do
    it "assigns the requested lab as @lab" do
      lab = Lab.create! valid_attributes
      get :edit, {:id => lab.to_param}, valid_session
      assigns(:lab).should eq(lab)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Lab" do
        expect {
          post :create, {:lab => valid_attributes}, valid_session
        }.to change(Lab, :count).by(1)
      end

      it "assigns a newly created lab as @lab" do
        post :create, {:lab => valid_attributes}, valid_session
        assigns(:lab).should be_a(Lab)
        assigns(:lab).should be_persisted
      end

      it "redirects to the created lab" do
        post :create, {:lab => valid_attributes}, valid_session
        response.should redirect_to(labs_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved lab as @lab" do
        # Trigger the behavior that occurs when invalid params are submitted
        Lab.any_instance.stub(:save).and_return(false)
        post :create, {:lab => {}}, valid_session
        assigns(:lab).should be_a_new(Lab)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Lab.any_instance.stub(:save).and_return(false)
        post :create, {:lab => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested lab" do
        lab = Lab.create! valid_attributes
        # Assuming there are no other labs in the database, this
        # specifies that the Lab created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Lab.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => lab.to_param, :lab => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested lab as @lab" do
        lab = Lab.create! valid_attributes
        put :update, {:id => lab.to_param, :lab => valid_attributes}, valid_session
        assigns(:lab).should eq(lab)
      end

      it "redirects to the lab" do
        lab = Lab.create! valid_attributes
        put :update, {:id => lab.to_param, :lab => valid_attributes}, valid_session
        response.should redirect_to(labs_path)
      end
    end

    describe "with invalid params" do
      it "assigns the lab as @lab" do
        lab = Lab.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Lab.any_instance.stub(:save).and_return(false)
        put :update, {:id => lab.to_param, :lab => {}}, valid_session
        assigns(:lab).should eq(lab)
      end

      it "re-renders the 'edit' template" do
        lab = Lab.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Lab.any_instance.stub(:save).and_return(false)
        put :update, {:id => lab.to_param, :lab => {}}, valid_session
        response.should render_template("edit")
      end
    end
    describe "With group in params" do
      it "should save the group in the lab" do
        lab = Lab.create! valid_attributes
        adminGroup = Group.find_by_name("Administrators")
        put :update, {:id => lab.to_param, :lab => {:groups => adminGroup.id}}, valid_session
        lab.groups.should include(adminGroup)
      end
      it "should not allow adding the group to the lab twice" do
        lab = Lab.create! valid_attributes
        adminGroup = Group.find_by_name("Administrators")
        put :update, {:id => lab.to_param, :lab => {:groups => adminGroup.id}}, valid_session
        put :update, {:id => lab.to_param, :lab => {:groups => adminGroup.id}}, valid_session
        flash[:error].should == "A group may not be added to the same lab multiple times."
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested lab" do
      lab = Lab.create! valid_attributes
      expect {
        delete :destroy, {:id => lab.to_param}, valid_session
      }.to change(Lab, :count).by(-1)
    end

    it "redirects to the labs list" do
      lab = Lab.create! valid_attributes
      delete :destroy, {:id => lab.to_param}, valid_session
      response.should redirect_to(labs_url)
    end
  end

end
