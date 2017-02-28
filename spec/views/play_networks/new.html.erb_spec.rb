require 'rails_helper'

RSpec.describe "play_networks/new", :type => :view do
  before(:each) do
    assign(:play_network, PlayNetwork.new(
      :name => "MyString"
    ))
  end

  it "renders new play_network form" do
    render

    assert_select "form[action=?][method=?]", play_networks_path, "post" do

      assert_select "input#play_network_name[name=?]", "play_network[name]"
    end
  end
end
