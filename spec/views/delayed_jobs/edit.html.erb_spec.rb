require 'rails_helper'

RSpec.describe "delayed_jobs/edit", :type => :view do
  before(:each) do
    @delayed_job = assign(:delayed_job, DelayedJob.create!())
  end

  it "renders the edit delayed_job form" do
    render

    assert_select "form[action=?][method=?]", delayed_job_path(@delayed_job), "post" do
    end
  end
end
