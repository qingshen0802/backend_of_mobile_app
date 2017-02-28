require 'rails_helper'

RSpec.describe "messages/new", :type => :view do
  before(:each) do
    assign(:message, Message.new(
      :playcelet_id => "MyString",
      :app_id => "MyString",
      :type => ""
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do

      assert_select "input#message_playcelet_id[name=?]", "message[playcelet_id]"

      assert_select "input#message_app_id[name=?]", "message[app_id]"

      assert_select "input#message_type[name=?]", "message[type]"
    end
  end
end
