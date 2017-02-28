require 'rails_helper'

RSpec.describe "neighbors_families_links/show", :type => :view do
  before(:each) do
    @neighbors_families_link = assign(:neighbors_families_link, NeighborsFamiliesLink.create!(
      :family => nil,
      :neighbor => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
