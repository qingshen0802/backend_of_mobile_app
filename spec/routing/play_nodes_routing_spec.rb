require "rails_helper"

RSpec.describe PlayNodesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/play_nodes").to route_to("play_nodes#index")
    end

    it "routes to #new" do
      expect(:get => "/play_nodes/new").to route_to("play_nodes#new")
    end

    it "routes to #show" do
      expect(:get => "/play_nodes/1").to route_to("play_nodes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/play_nodes/1/edit").to route_to("play_nodes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/play_nodes").to route_to("play_nodes#create")
    end

    it "routes to #update" do
      expect(:put => "/play_nodes/1").to route_to("play_nodes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/play_nodes/1").to route_to("play_nodes#destroy", :id => "1")
    end

  end
end
