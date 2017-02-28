require 'rails_helper'

RSpec.describe "playcelets/show", :type => :view do
  before(:each) do
    @playcelet = assign(:playcelet, Playcelet.create!(
      :color => "Color",
      :playcelet_id => "Playcelet"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Color/)
    expect(rendered).to match(/Playcelet/)
  end
end
