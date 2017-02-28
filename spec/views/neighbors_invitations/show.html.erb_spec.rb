require 'rails_helper'

RSpec.describe "neighbors_invitations/show", :type => :view do
  before(:each) do
    @neighbors_invitation = assign(:neighbors_invitation, NeighborsInvitation.create!(
      :family => nil,
      :neighbor => nil,
      :status => "Status",
      :user => nil,
      :initial_text => "Initial Text",
      :respond_by => nil,
      :response_text => "Response Text"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Initial Text/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Response Text/)
  end
end
