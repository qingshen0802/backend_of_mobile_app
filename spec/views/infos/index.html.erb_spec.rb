require 'rails_helper'

RSpec.describe "infos/index", :type => :view do
  before(:each) do
    assign(:infos, [
      Info.create!(
        :message_type => "Message Type",
        :app_id => 1,
        :playcelet_id => 2
      ),
      Info.create!(
        :message_type => "Message Type",
        :app_id => 1,
        :playcelet_id => 2
      )
    ])
  end

  it "renders a list of infos" do
    render
    assert_select "tr>td", :text => "Message Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
