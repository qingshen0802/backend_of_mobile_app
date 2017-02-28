require 'rails_helper'

RSpec.describe "neighbors_families_links/index", :type => :view do
  before(:each) do
    assign(:neighbors_families_links, [
      NeighborsFamiliesLink.create!(
        :family => nil,
        :neighbor => nil
      ),
      NeighborsFamiliesLink.create!(
        :family => nil,
        :neighbor => nil
      )
    ])
  end

  it "renders a list of neighbors_families_links" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
