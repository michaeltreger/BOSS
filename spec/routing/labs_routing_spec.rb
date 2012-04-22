require "spec_helper"

describe LabsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/labs").should route_to("labs#index")
    end

    it "routes to #new" do
      get("/admin/labs/new").should route_to("labs#new")
    end

    it "routes to #show" do
      get("/admin/labs/1").should route_to("labs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/labs/1/edit").should route_to("labs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/labs").should route_to("labs#create")
    end

    it "routes to #update" do
      put("/admin/labs/1").should route_to("labs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/labs/1").should route_to("labs#destroy", :id => "1")
    end

  end
end
