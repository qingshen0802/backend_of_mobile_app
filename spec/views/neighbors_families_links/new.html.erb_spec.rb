require 'rails_helper'

RSpec.describe "neighbors_families_links/new", :type => :view do
  before(:each) do
    assign(:neighbors_families_link, NeighborsFamiliesLink.new(
      :family => nil,
      :neighbor => nil
    ))
  end

  it "renders new neighbors_families_link form" do
    render

    assert_select "form[action=?][method=?]", neighbors_families_links_path, "post" do

      assert_select "input#neighbors_families_link_family_id[name=?]", "neighbors_families_link[family_id]"

      assert_select "input#neighbors_families_link_neighbor_id[name=?]", "neighbors_families_link[neighbor_id]"
    end
  end
end
