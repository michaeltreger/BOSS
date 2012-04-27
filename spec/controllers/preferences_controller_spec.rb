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

describe PreferencesController do
  before(:each) do
      @user = User.create!(:user_type => 1, :name => 'Tom', :activated => 'true', :initials => 'T')
      @calendar = Calendar.create!(:user_id => @user.id, :name => "#{@user.name}'s calendar",:calendar_type => 1)
  end

  # This should return the minimal set of attributes required to create a valid
  # Preference. As you add validations to Preference, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PreferencesController. Be sure to keep this updated too.
  def valid_session
    {:test_user_id => @user.id}
  end

  describe "GET index" do
    it "assigns all preferences as @preferences" do
      preference = Preference.create! valid_attributes
      get :index, {}, valid_session
      assigns(:preferences).should eq([preference])
    end
  end

  describe "GET show" do
    it "assigns the requested preference as @preference" do
      preference = Preference.create! valid_attributes
      get :show, {:id => preference.to_param}, valid_session
      assigns(:preference).should eq(preference)
    end
  end

  describe "GET new" do
    it "assigns a new preference as @preference" do
      get :new, {}, valid_session
      assigns(:preference).should be_a_new(Preference)
    end
  end

  describe "GET edit" do
    it "assigns the requested preference as @preference" do
      preference = Preference.create! valid_attributes
      get :edit, {:id => preference.to_param}, valid_session
      assigns(:preference).should eq(preference)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Preference" do
        expect {
          post :create, {:preference => valid_attributes}, valid_session
        }.to change(Preference, :count).by(1)
      end

      it "assigns a newly created preference as @preference" do
        post :create, {:preference => valid_attributes}, valid_session
        assigns(:preference).should be_a(Preference)
        assigns(:preference).should be_persisted
      end

      it "redirects to the created preference" do
        post :create, {:preference => valid_attributes}, valid_session
        response.should redirect_to(Preference.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved preference as @preference" do
        # Trigger the behavior that occurs when invalid params are submitted
        Preference.any_instance.stub(:save).and_return(false)
        post :create, {:preference => {}}, valid_session
        assigns(:preference).should be_a_new(Preference)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Preference.any_instance.stub(:save).and_return(false)
        post :create, {:preference => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested preference" do
        preference = Preference.create! valid_attributes
        # Assuming there are no other preferences in the database, this
        # specifies that the Preference created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Preference.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => preference.to_param, :preference => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested preference as @preference" do
        preference = Preference.create! valid_attributes
        put :update, {:id => preference.to_param, :preference => valid_attributes}, valid_session
        assigns(:preference).should eq(preference)
      end

      it "redirects to the preference" do
        preference = Preference.create! valid_attributes
        put :update, {:id => preference.to_param, :preference => valid_attributes}, valid_session
        response.should redirect_to(preference)
      end
    end

    describe "with invalid params" do
      it "assigns the preference as @preference" do
        preference = Preference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Preference.any_instance.stub(:save).and_return(false)
        put :update, {:id => preference.to_param, :preference => {}}, valid_session
        assigns(:preference).should eq(preference)
      end

      it "re-renders the 'edit' template" do
        preference = Preference.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Preference.any_instance.stub(:save).and_return(false)
        put :update, {:id => preference.to_param, :preference => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested preference" do
      preference = Preference.create! valid_attributes
      expect {
        delete :destroy, {:id => preference.to_param}, valid_session
      }.to change(Preference, :count).by(-1)
    end

    it "redirects to the preferences list" do
      preference = Preference.create! valid_attributes
      delete :destroy, {:id => preference.to_param}, valid_session
      response.should redirect_to(preferences_url)
    end
  end

end
