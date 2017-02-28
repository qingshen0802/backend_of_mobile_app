require 'rails_helper'

RSpec.describe "neighbors_invitations/edit", :type => :view do
  before(:each) do
    @neighbors_invitation = assign(:neighbors_invitation, NeighborsInvitation.create!(
      :family => nil,
      :neighbor => nil,
      :status => "MyString",
      :user => nil,
      :initial_text => "MyString",
      :respond_by => nil,
      :response_text => "MyString"
    ))
  end

  it "renders the edit neighbors_invitation form" do
    render

    assert_select "form[action=?][method=?]", neighbors_invitation_path(@neighbors_invitation), "post" do

      assert_select "input#neighbors_invitation_family_id[name=?]", "neighbors_invitation[family_id]"

      assert_select "input#neighbors_invitation_neighbor_id[name=?]", "neighbors_invitation[neighbor_id]"

      assert_select "input#neighbors_invitation_status[name=?]", "neighbors_invitation[status]"

      assert_select "input#neighbors_invitation_user_id[name=?]", "neighbors_invitation[user_id]"

      assert_select "input#neighbors_invitation_initial_text[name=?]", "neighbors_invitation[initial_text]"

      assert_select "input#neighbors_invitation_respond_by_id[name=?]", "neighbors_invitation[respond_by_id]"

      assert_select "input#neighbors_invitation_response_text[name=?]", "neighbors_invitation[response_text]"
    end
  end
end
