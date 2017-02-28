require 'rails_helper'

RSpec.describe "playcelets/new", :type => :view do
  before(:each) do
    assign(:playcelet, Playcelet.new(
      :color => "MyString",
      :playcelet_id => "MyString"
    ))
  end

  it "renders new playcelet form" do
    render

    assert_select "form[action=?][method=?]", playcelets_path, "post" do

      assert_select "input#playcelet_color[name=?]", "playcelet[color]"

      assert_select "input#playcelet_playcelet_id[name=?]", "playcelet[playcelet_id]"
    end
  end
end
