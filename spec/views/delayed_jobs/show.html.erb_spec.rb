require 'rails_helper'

RSpec.describe "delayed_jobs/show", :type => :view do
  before(:each) do
    @delayed_job = assign(:delayed_job, DelayedJob.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
