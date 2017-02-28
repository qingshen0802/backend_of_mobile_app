require 'rails_helper'

RSpec.describe "NeighborsFamiliesLinks", :type => :request do
  describe "GET /neighbors_families_links" do
    it "works! (now write some real specs)" do
      get neighbors_families_links_path
      expect(response.status).to be(200)
    end
  end
end
