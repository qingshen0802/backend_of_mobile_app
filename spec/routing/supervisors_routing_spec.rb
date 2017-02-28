require "rails_helper"

RSpec.describe SupervisorsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/supervisors").to route_to("supervisors#index")
    end

    it "routes to #new" do
      expect(:get => "/supervisors/new").to route_to("supervisors#new")
    end

    it "routes to #show" do
      expect(:get => "/supervisors/1").to route_to("supervisors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/supervisors/1/edit").to route_to("supervisors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/supervisors").to route_to("supervisors#create")
    end

    it "routes to #update" do
      expect(:put => "/supervisors/1").to route_to("supervisors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/supervisors/1").to route_to("supervisors#destroy", :id => "1")
    end

  end
end
