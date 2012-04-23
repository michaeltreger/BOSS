require "spec_helper"

describe PeriodsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/periods").should route_to("periods#index")
    end

    it "routes to #new" do
      get("/admin/periods/new").should route_to("periods#new")
    end

    it "routes to #show" do
      get("/admin/periods/1").should route_to("periods#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/periods/1/edit").should route_to("periods#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/periods").should route_to("periods#create")
    end

    it "routes to #update" do
      put("/admin/periods/1").should route_to("periods#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/periods/1").should route_to("periods#destroy", :id => "1")
    end

  end
end
