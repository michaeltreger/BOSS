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
      User.create!(:user_type => 1, :name => 'Tom', :approved => 'true', :initials => 'T')
      session[:test_user_id] = 1
      Entry.create!(:user_id => '1', :substitution_id => '1', :calendar_id => '1', :start_time => '8:00am', :end_time => '12:00pm')
  end

  describe "GET index" do
    it "should assign all subtitutions as @substitutions" do
      get :index
      assigns(:substitutions).count.should == 1
    end
    it "should render to index page" do
      get :index
      response.should render_template('index')
    end
  end

  describe "GET new" do
    it "assigns a new substitution as @substitution" do
      substitution = mock('Substitution')
      Substitution.stub(:new).and_return(substitution)
      get :new, {:current_user => User.create!(:user_type => 1, :name => 'Tom', :approved => 'true', :initials => 'T')}
      assigns(:substitution).should == substitution
    end
  end

  describe "GET edit" do
    it "assigns the requested substitution as @substitution" do
      substitution = mock('Substitution')
      Substitution.stub(:find).with('1').and_return(substitution)
      get :edit, {:id => '1'}
      assigns(:substitution).should == substitution
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Substitution" do
        post :create, {:substitution => {:users => '1', :user_id => '1', :entry => '1', :entry_id => '1', :description => 'params'}}
        Substitution.count.should == 1
      end

      it "re-renders to the 'new' template" do
        post :create, {:substitution => {:users => '1', :user_id => '1', :entry => '1', :entry_id => '1', :description => 'params'}}
        response.should redirect_to new_substitution_path
        flash[:notice].should == 'Substitution was successfully created.'
      end
    end

    describe "with invalid params" do
      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Substitution.any_instance.stub(:save).and_return(false)
          post :create, {:substitution => {:users => '1', :user_id => '1', :entry => '1', :entry_id => '1', :description => 'params'}}
        response.should render_template("new")
        flash[:notice].should == 'Substitution could not be created.'
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested substitution" do
        substitution = mock('Substitution')
        Substitution.stub(:find).with('1').and_return(substitution)
        substitution.should_receive(:update_attributes).with({"user_id" => '1', "entry" => '1', "entry_id" => '1', "description" => 'params'})
        put :update, {:id => '1', :substitution => {:user_id => '1', :entry => '1', :entry_id => '1', :description => 'params'}}
      end

      it "assigns the requested substitution as @substitution" do
        substitution = Substitution.create!(:description => 'haha',:entry =>Entry.new)
        put :update, {:id => '1', :substitution => {:user_id => '1', :entry_id => '1', :description => 'params'}}
        assigns(:substitution).should == substitution
      end

      it "redirects to the substitution" do
        substitution = Substitution.create!(:description => 'haha',:entry =>Entry.new)
        put :update, {:id => '1', :substitution => {:user_id => '1', :entry_id => '1', :description => 'params'}}
        response.should redirect_to(substitution)
        flash[:notice].should == 'Substitution was successfully updated.'
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
