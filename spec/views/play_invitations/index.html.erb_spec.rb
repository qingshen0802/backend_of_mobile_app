require 'rails_helper'

RSpec.describe "play_invitations/index", :type => :view do
  before(:each) do
    assign(:play_invitations, [
      PlayInvitation.create!(
        :playcelet => nil,
        :invited_playcelet => nil,
        :app => nil,
        :respond_by => nil,
        :response_text => "Response Text",
        :status => "Status"
      ),
      PlayInvitation.create!(
        :playcelet => nil,
        :invited_playcelet => nil,
        :app => nil,
        :respond_by => nil,
        :response_text => "Response Text",
        :status => "Status"
      )
    ])
  end

  it "renders a list of play_invitations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Response Text".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
