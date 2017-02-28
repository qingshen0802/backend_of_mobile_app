require 'rails_helper'

RSpec.describe "children/edit", :type => :view do
  before(:each) do
    @child = assign(:child, Child.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :family_id => 1,
      :playcelet_id => "MyString",
      :color => "MyString"
    ))
  end

  it "renders the edit child form" do
    render

    assert_select "form[action=?][method=?]", child_path(@child), "post" do

      assert_select "input#child_first_name[name=?]", "child[first_name]"

      assert_select "input#child_last_name[name=?]", "child[last_name]"

      assert_select "input#child_family_id[name=?]", "child[family_id]"

      assert_select "input#child_playcelet_id[name=?]", "child[playcelet_id]"

      assert_select "input#child_color[name=?]", "child[color]"
    end
  end
end
