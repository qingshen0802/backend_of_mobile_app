require 'rails_helper'

RSpec.describe "Supervisors", :type => :request do
  describe "GET /supervisors" do
    it "works! (now write some real specs)" do
      get supervisors_path
      expect(response.status).to be(200)
    end
  end
end
