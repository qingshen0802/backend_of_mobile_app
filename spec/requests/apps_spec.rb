require 'rails_helper'

RSpec.describe "Apps", :type => :request do
  describe "GET /apps" do
    it "works! (now write some real specs)" do
      get apps_path
      expect(response.status).to be(200)
    end
  end
end
