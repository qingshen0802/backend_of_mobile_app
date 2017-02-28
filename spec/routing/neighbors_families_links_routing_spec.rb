require "rails_helper"

RSpec.describe NeighborsFamiliesLinksController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/neighbors_families_links").to route_to("neighbors_families_links#index")
    end

    it "routes to #new" do
      expect(:get => "/neighbors_families_links/new").to route_to("neighbors_families_links#new")
    end

    it "routes to #show" do
      expect(:get => "/neighbors_families_links/1").to route_to("neighbors_families_links#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/neighbors_families_links/1/edit").to route_to("neighbors_families_links#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/neighbors_families_links").to route_to("neighbors_families_links#create")
    end

    it "routes to #update" do
      expect(:put => "/neighbors_families_links/1").to route_to("neighbors_families_links#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/neighbors_families_links/1").to route_to("neighbors_families_links#destroy", :id => "1")
    end

  end
end
