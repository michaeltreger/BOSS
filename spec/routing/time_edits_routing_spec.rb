require "spec_helper"

describe TimeEditsController do
  describe "routing" do

    it "routes to #index" do
      get("/time_edits").should route_to("time_edits#index")
    end

    it "routes to #new" do
      get("/time_edits/new").should route_to("time_edits#new")
    end

    it "routes to #show" do
      get("/time_edits/1").should route_to("time_edits#show", :id => "1")
    end

    it "routes to #edit" do
      get("/time_edits/1/edit").should route_to("time_edits#edit", :id => "1")
    end

    it "routes to #create" do
      post("/time_edits").should route_to("time_edits#create")
    end

    it "routes to #update" do
      put("/time_edits/1").should route_to("time_edits#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/time_edits/1").should route_to("time_edits#destroy", :id => "1")
    end

  end
end
