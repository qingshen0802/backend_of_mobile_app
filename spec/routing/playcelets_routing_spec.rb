require "rails_helper"

RSpec.describe PlayceletsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/playcelets").to route_to("playcelets#index")
    end

    it "routes to #new" do
      expect(:get => "/playcelets/new").to route_to("playcelets#new")
    end

    it "routes to #show" do
      expect(:get => "/playcelets/1").to route_to("playcelets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/playcelets/1/edit").to route_to("playcelets#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/playcelets").to route_to("playcelets#create")
    end

    it "routes to #update" do
      expect(:put => "/playcelets/1").to route_to("playcelets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/playcelets/1").to route_to("playcelets#destroy", :id => "1")
    end

  end
end
