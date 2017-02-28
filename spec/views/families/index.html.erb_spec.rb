require 'rails_helper'

RSpec.describe "families/index", :type => :view do
  before(:each) do
    assign(:families, [
      Family.create!(
        :name => "Name",
        :address => "Address"
      ),
      Family.create!(
        :name => "Name",
        :address => "Address"
      )
    ])
  end

  it "renders a list of families" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
  end
end
