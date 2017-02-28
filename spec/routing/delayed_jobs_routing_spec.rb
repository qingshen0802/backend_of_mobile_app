require "rails_helper"

RSpec.describe DelayedJobsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/delayed_jobs").to route_to("delayed_jobs#index")
    end

    it "routes to #new" do
      expect(:get => "/delayed_jobs/new").to route_to("delayed_jobs#new")
    end

    it "routes to #show" do
      expect(:get => "/delayed_jobs/1").to route_to("delayed_jobs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/delayed_jobs/1/edit").to route_to("delayed_jobs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/delayed_jobs").to route_to("delayed_jobs#create")
    end

    it "routes to #update" do
      expect(:put => "/delayed_jobs/1").to route_to("delayed_jobs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/delayed_jobs/1").to route_to("delayed_jobs#destroy", :id => "1")
    end

  end
end
