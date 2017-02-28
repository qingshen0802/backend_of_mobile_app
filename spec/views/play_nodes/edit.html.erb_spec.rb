require 'rails_helper'

RSpec.describe "play_nodes/edit", :type => :view do
  before(:each) do
    @play_node = assign(:play_node, PlayNode.create!(
      :child => nil,
      :play_network => nil
    ))
  end

  it "renders the edit play_node form" do
    render

    assert_select "form[action=?][method=?]", play_node_path(@play_node), "post" do

      assert_select "input#play_node_child_id[name=?]", "play_node[child_id]"

      assert_select "input#play_node_play_network_id[name=?]", "play_node[play_network_id]"
    end
  end
end
