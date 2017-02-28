require "rails_helper"

RSpec.describe PlayNetworksController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/play_networks").to route_to("play_networks#index")
    end

    it "routes to #new" do
      expect(:get => "/play_networks/new").to route_to("play_networks#new")
    end

    it "routes to #show" do
      expect(:get => "/play_networks/1").to route_to("play_networks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/play_networks/1/edit").to route_to("play_networks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/play_networks").to route_to("play_networks#create")
    end

    it "routes to #update" do
      expect(:put => "/play_networks/1").to route_to("play_networks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/play_networks/1").to route_to("play_networks#destroy", :id => "1")
    end

  end
end
