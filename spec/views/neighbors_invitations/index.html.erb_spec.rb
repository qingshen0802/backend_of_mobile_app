require 'rails_helper'

RSpec.describe "neighbors_invitations/index", :type => :view do
  before(:each) do
    assign(:neighbors_invitations, [
      NeighborsInvitation.create!(
        :family => nil,
        :neighbor => nil,
        :status => "Status",
        :user => nil,
        :initial_text => "Initial Text",
        :respond_by => nil,
        :response_text => "Response Text"
      ),
      NeighborsInvitation.create!(
        :family => nil,
        :neighbor => nil,
        :status => "Status",
        :user => nil,
        :initial_text => "Initial Text",
        :respond_by => nil,
        :response_text => "Response Text"
      )
    ])
  end

  it "renders a list of neighbors_invitations" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Initial Text".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Response Text".to_s, :count => 2
  end
end
