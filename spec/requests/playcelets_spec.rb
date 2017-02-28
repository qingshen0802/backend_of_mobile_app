require 'rails_helper'

RSpec.describe "Playcelets", :type => :request do
  describe "GET /playcelets" do
    it "works! (now write some real specs)" do
      get playcelets_path
      expect(response.status).to be(200)
    end
  end
end
