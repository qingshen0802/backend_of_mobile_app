require 'rails_helper'

RSpec.describe "infos/edit", :type => :view do
  before(:each) do
    @info = assign(:info, Info.create!(
      :message_type => "MyString",
      :app_id => 1,
      :playcelet_id => 1
    ))
  end

  it "renders the edit info form" do
    render

    assert_select "form[action=?][method=?]", info_path(@info), "post" do

      assert_select "input#info_message_type[name=?]", "info[message_type]"

      assert_select "input#info_app_id[name=?]", "info[app_id]"

      assert_select "input#info_playcelet_id[name=?]", "info[playcelet_id]"
    end
  end
end
