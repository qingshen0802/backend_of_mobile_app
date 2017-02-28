require 'rails_helper'

RSpec.describe "play_networks/index", :type => :view do
  before(:each) do
    assign(:play_networks, [
      PlayNetwork.create!(
        :name => "Name"
      ),
      PlayNetwork.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of play_networks" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
