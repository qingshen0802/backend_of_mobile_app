require 'rails_helper'

RSpec.describe "play_nodes/index", :type => :view do
  before(:each) do
    assign(:play_nodes, [
      PlayNode.create!(
        :child => nil,
        :play_network => nil
      ),
      PlayNode.create!(
        :child => nil,
        :play_network => nil
      )
    ])
  end

  it "renders a list of play_nodes" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
