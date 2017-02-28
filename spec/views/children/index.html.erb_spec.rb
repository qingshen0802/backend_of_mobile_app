require 'rails_helper'

RSpec.describe "children/index", :type => :view do
  before(:each) do
    assign(:children, [
      Child.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :family_id => 1,
        :playcelet_id => "Playcelet",
        :color => "Color"
      ),
      Child.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :family_id => 1,
        :playcelet_id => "Playcelet",
        :color => "Color"
      )
    ])
  end

  it "renders a list of children" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Playcelet".to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
  end
end
