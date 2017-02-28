require 'rails_helper'

RSpec.describe "DelayedJobs", :type => :request do
  describe "GET /delayed_jobs" do
    it "works! (now write some real specs)" do
      get delayed_jobs_path
      expect(response.status).to be(200)
    end
  end
end
