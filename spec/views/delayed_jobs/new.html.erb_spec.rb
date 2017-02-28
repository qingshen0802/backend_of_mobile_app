require 'rails_helper'

RSpec.describe "delayed_jobs/new", :type => :view do
  before(:each) do
    assign(:delayed_job, DelayedJob.new())
  end

  it "renders new delayed_job form" do
    render

    assert_select "form[action=?][method=?]", delayed_jobs_path, "post" do
    end
  end
end
