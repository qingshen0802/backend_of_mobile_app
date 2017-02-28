require 'rails_helper'

RSpec.describe "NeighborsInvitations", :type => :request do
  describe "GET /neighbors_invitations" do
    it "works! (now write some real specs)" do
      get neighbors_invitations_path
      expect(response.status).to be(200)
    end
  end
end
