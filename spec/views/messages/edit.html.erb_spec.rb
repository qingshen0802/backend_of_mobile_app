require 'rails_helper'

RSpec.describe "messages/edit", :type => :view do
  before(:each) do
    @message = assign(:message, Message.create!(
      :playcelet_id => "MyString",
      :app_id => "MyString",
      :type => ""
    ))
  end

  it "renders the edit message form" do
    render

    assert_select "form[action=?][method=?]", message_path(@message), "post" do

      assert_select "input#message_playcelet_id[name=?]", "message[playcelet_id]"

      assert_select "input#message_app_id[name=?]", "message[app_id]"

      assert_select "input#message_type[name=?]", "message[type]"
    end
  end
end
