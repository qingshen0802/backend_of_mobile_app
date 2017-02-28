require 'rails_helper'

RSpec.describe "play_nodes/new", :type => :view do
  before(:each) do
    assign(:play_node, PlayNode.new(
      :child => nil,
      :play_network => nil
    ))
  end

  it "renders new play_node form" do
    render

    assert_select "form[action=?][method=?]", play_nodes_path, "post" do

      assert_select "input#play_node_child_id[name=?]", "play_node[child_id]"

      assert_select "input#play_node_play_network_id[name=?]", "play_node[play_network_id]"
    end
  end
end
