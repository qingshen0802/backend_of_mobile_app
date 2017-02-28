require 'rails_helper'

RSpec.describe "play_networks/show", :type => :view do
  before(:each) do
    @play_network = assign(:play_network, PlayNetwork.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
