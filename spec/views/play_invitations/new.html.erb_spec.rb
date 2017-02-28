require 'rails_helper'

RSpec.describe "play_invitations/new", :type => :view do
  before(:each) do
    assign(:play_invitation, PlayInvitation.new(
      :playcelet => nil,
      :invited_playcelet => nil,
      :app => nil,
      :respond_by => nil,
      :response_text => "MyString",
      :status => "MyString"
    ))
  end

  it "renders new play_invitation form" do
    render

    assert_select "form[action=?][method=?]", play_invitations_path, "post" do

      assert_select "input#play_invitation_playcelet_id[name=?]", "play_invitation[playcelet_id]"

      assert_select "input#play_invitation_invited_playcelet_id[name=?]", "play_invitation[invited_playcelet_id]"

      assert_select "input#play_invitation_app_id[name=?]", "play_invitation[app_id]"

      assert_select "input#play_invitation_respond_by_id[name=?]", "play_invitation[respond_by_id]"

      assert_select "input#play_invitation_response_text[name=?]", "play_invitation[response_text]"

      assert_select "input#play_invitation_status[name=?]", "play_invitation[status]"
    end
  end
end
