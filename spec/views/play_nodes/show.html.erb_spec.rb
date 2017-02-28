require 'rails_helper'

RSpec.describe "play_nodes/show", :type => :view do
  before(:each) do
    @play_node = assign(:play_node, PlayNode.create!(
      :child => nil,
      :play_network => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
