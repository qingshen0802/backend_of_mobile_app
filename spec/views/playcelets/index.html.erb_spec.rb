require 'rails_helper'

RSpec.describe "playcelets/index", :type => :view do
  before(:each) do
    assign(:playcelets, [
      Playcelet.create!(
        :color => "Color",
        :playcelet_id => "Playcelet"
      ),
      Playcelet.create!(
        :color => "Color",
        :playcelet_id => "Playcelet"
      )
    ])
  end

  it "renders a list of playcelets" do
    render
    assert_select "tr>td", :text => "Color".to_s, :count => 2
    assert_select "tr>td", :text => "Playcelet".to_s, :count => 2
  end
end
