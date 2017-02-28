require 'rails_helper'

RSpec.describe "PlayNetworks", :type => :request do
  describe "GET /play_networks" do
    it "works! (now write some real specs)" do
      get play_networks_path
      expect(response.status).to be(200)
    end
  end
end
