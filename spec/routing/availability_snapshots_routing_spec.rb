require "spec_helper"

describe AvailabilitySnapshotsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/availability_snapshots").should route_to("availability_snapshots#index")
    end

    it "routes to #new" do
      get("/admin/availability_snapshots/new").should route_to("availability_snapshots#new")
    end

    it "routes to #show" do
      get("/admin/availability_snapshots/1").should route_to("availability_snapshots#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/availability_snapshots/1/edit").should route_to("availability_snapshots#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/availability_snapshots").should route_to("availability_snapshots#create")
    end

    it "routes to #update" do
      put("/admin/availability_snapshots/1").should route_to("availability_snapshots#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/availability_snapshots/1").should route_to("availability_snapshots#destroy", :id => "1")
    end

  end
end
