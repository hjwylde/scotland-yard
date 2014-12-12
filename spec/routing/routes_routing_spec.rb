require "rails_helper"

RSpec.describe RoutesController, :type => :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/routes").to route_to("routes#index")
    end

    it "routes to #new" do
      expect(:get => "/routes/new").to route_to("routes#new")
    end

    it "routes to #show" do
      expect(:get => "/routes/1").to route_to("routes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/routes/1/edit").to route_to("routes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/routes").to route_to("routes#create")
    end

    it "routes to #update" do
      expect(:put => "/routes/1").to route_to("routes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/routes/1").to route_to("routes#destroy", :id => "1")
    end
  end
end

