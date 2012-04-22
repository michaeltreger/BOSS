require "spec_helper"

describe PreferencesController do
  describe "routing" do

    it "routes to #index" do
      get("/preferences").should route_to("preferences#index")
    end

    it "routes to #new" do
      get("/preferences/new").should route_to("preferences#new")
    end

    it "routes to #show" do
      get("/preferences/1").should route_to("preferences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/preferences/1/edit").should route_to("preferences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/preferences").should route_to("preferences#create")
    end

    it "routes to #update" do
      put("/preferences/1").should route_to("preferences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/preferences/1").should route_to("preferences#destroy", :id => "1")
    end

  end
end
