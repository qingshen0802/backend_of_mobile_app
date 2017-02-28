require 'rails_helper'

RSpec.describe "EventLogs", :type => :request do
  describe "GET /event_logs" do
    it "works! (now write some real specs)" do
      get event_logs_path
      expect(response.status).to be(200)
    end
  end
end
