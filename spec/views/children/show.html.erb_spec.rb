require 'rails_helper'

RSpec.describe "children/show", :type => :view do
  before(:each) do
    @child = assign(:child, Child.create!(
      :first_name => "First Name",
      :last_name => "Last Name",
      :family_id => 1,
      :playcelet_id => "Playcelet",
      :color => "Color"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Playcelet/)
    expect(rendered).to match(/Color/)
  end
end
