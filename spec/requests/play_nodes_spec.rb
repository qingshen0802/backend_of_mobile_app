require 'rails_helper'

RSpec.describe "PlayNodes", :type => :request do
  describe "GET /play_nodes" do
    it "works! (now write some real specs)" do
      get play_nodes_path
      expect(response.status).to be(200)
    end
  end
end
