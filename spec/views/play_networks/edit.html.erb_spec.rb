require 'rails_helper'

RSpec.describe "play_networks/edit", :type => :view do
  before(:each) do
    @play_network = assign(:play_network, PlayNetwork.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit play_network form" do
    render

    assert_select "form[action=?][method=?]", play_network_path(@play_network), "post" do

      assert_select "input#play_network_name[name=?]", "play_network[name]"
    end
  end
end
