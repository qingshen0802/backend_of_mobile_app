require 'rails_helper'

RSpec.describe "families/new", :type => :view do
  before(:each) do
    assign(:family, Family.new(
      :name => "MyString",
      :address => "MyString"
    ))
  end

  it "renders new family form" do
    render

    assert_select "form[action=?][method=?]", families_path, "post" do

      assert_select "input#family_name[name=?]", "family[name]"

      assert_select "input#family_address[name=?]", "family[address]"
    end
  end
end
