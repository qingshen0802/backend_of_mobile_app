require 'rails_helper'

RSpec.describe "play_invitations/show", :type => :view do
  before(:each) do
    @play_invitation = assign(:play_invitation, PlayInvitation.create!(
      :playcelet => nil,
      :invited_playcelet => nil,
      :app => nil,
      :respond_by => nil,
      :response_text => "Response Text",
      :status => "Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Response Text/)
    expect(rendered).to match(/Status/)
  end
end
