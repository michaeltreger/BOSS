require "spec_helper"

describe SubstitutionsController do
  describe "routing" do

    it "routes to #index" do
      get("/substitutions").should route_to("substitutions#index")
    end

    it "routes to #new" do
      get("/substitutions/new").should route_to("substitutions#new")
    end

    it "routes to #show" do
      get("/substitutions/1").should route_to("substitutions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/substitutions/1/edit").should route_to("substitutions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/substitutions").should route_to("substitutions#create")
    end

    it "routes to #update" do
      put("/substitutions/1").should route_to("substitutions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/substitutions/1").should route_to("substitutions#destroy", :id => "1")
    end

  end
end
