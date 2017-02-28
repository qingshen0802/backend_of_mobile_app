require "rails_helper"

RSpec.describe NeighborsInvitationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/neighbors_invitations").to route_to("neighbors_invitations#index")
    end

    it "routes to #new" do
      expect(:get => "/neighbors_invitations/new").to route_to("neighbors_invitations#new")
    end

    it "routes to #show" do
      expect(:get => "/neighbors_invitations/1").to route_to("neighbors_invitations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/neighbors_invitations/1/edit").to route_to("neighbors_invitations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/neighbors_invitations").to route_to("neighbors_invitations#create")
    end

    it "routes to #update" do
      expect(:put => "/neighbors_invitations/1").to route_to("neighbors_invitations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/neighbors_invitations/1").to route_to("neighbors_invitations#destroy", :id => "1")
    end

  end
end
