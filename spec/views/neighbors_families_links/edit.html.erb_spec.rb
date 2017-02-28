require 'rails_helper'

RSpec.describe "neighbors_families_links/edit", :type => :view do
  before(:each) do
    @neighbors_families_link = assign(:neighbors_families_link, NeighborsFamiliesLink.create!(
      :family => nil,
      :neighbor => nil
    ))
  end

  it "renders the edit neighbors_families_link form" do
    render

    assert_select "form[action=?][method=?]", neighbors_families_link_path(@neighbors_families_link), "post" do

      assert_select "input#neighbors_families_link_family_id[name=?]", "neighbors_families_link[family_id]"

      assert_select "input#neighbors_families_link_neighbor_id[name=?]", "neighbors_families_link[neighbor_id]"
    end
  end
end
