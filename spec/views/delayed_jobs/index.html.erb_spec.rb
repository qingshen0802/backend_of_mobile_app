require 'rails_helper'

RSpec.describe "delayed_jobs/index", :type => :view do
  before(:each) do
    assign(:delayed_jobs, [
      DelayedJob.create!(),
      DelayedJob.create!()
    ])
  end

  it "renders a list of delayed_jobs" do
    render
  end
end
