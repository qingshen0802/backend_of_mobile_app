require 'rails_helper'

RSpec.describe "PlayInvitations", :type => :request do
  describe "GET /play_invitations" do
    it "works! (now write some real specs)" do
      get play_invitations_path
      expect(response.status).to be(200)
    end
  end
end
