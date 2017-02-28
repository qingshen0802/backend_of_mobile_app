require 'rails_helper'

RSpec.describe "messages/index", :type => :view do
  before(:each) do
    assign(:messages, [
      Message.create!(
        :playcelet_id => "Playcelet",
        :app_id => "App",
        :type => "Type"
      ),
      Message.create!(
        :playcelet_id => "Playcelet",
        :app_id => "App",
        :type => "Type"
      )
    ])
  end

  it "renders a list of messages" do
    render
    assert_select "tr>td", :text => "Playcelet".to_s, :count => 2
    assert_select "tr>td", :text => "App".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
  end
end
