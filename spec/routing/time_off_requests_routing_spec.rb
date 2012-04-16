require "spec_helper"

describe TimeOffRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/time_off_requests").should route_to("time_off_requests#index")
    end

    it "routes to #new" do
      get("/time_off_requests/new").should route_to("time_off_requests#new")
    end

    it "routes to #show" do
      get("/time_off_requests/1").should route_to("time_off_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/time_off_requests/1/edit").should route_to("time_off_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/time_off_requests").should route_to("time_off_requests#create")
    end

    it "routes to #update" do
      put("/time_off_requests/1").should route_to("time_off_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/time_off_requests/1").should route_to("time_off_requests#destroy", :id => "1")
    end

  end
end
