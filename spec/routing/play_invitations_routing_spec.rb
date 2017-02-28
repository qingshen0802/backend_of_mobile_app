require "rails_helper"

RSpec.describe PlayInvitationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/play_invitations").to route_to("play_invitations#index")
    end

    it "routes to #new" do
      expect(:get => "/play_invitations/new").to route_to("play_invitations#new")
    end

    it "routes to #show" do
      expect(:get => "/play_invitations/1").to route_to("play_invitations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/play_invitations/1/edit").to route_to("play_invitations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/play_invitations").to route_to("play_invitations#create")
    end

    it "routes to #update" do
      expect(:put => "/play_invitations/1").to route_to("play_invitations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/play_invitations/1").to route_to("play_invitations#destroy", :id => "1")
    end

  end
end
