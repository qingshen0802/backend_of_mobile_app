require 'rails_helper'

RSpec.describe "Children", :type => :request do
  describe "GET /children" do
    it "works! (now write some real specs)" do
      get children_path
      expect(response.status).to be(200)
    end
  end
end
