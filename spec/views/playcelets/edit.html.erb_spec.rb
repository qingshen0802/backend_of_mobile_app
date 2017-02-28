require 'rails_helper'

RSpec.describe "playcelets/edit", :type => :view do
  before(:each) do
    @playcelet = assign(:playcelet, Playcelet.create!(
      :color => "MyString",
      :playcelet_id => "MyString"
    ))
  end

  it "renders the edit playcelet form" do
    render

    assert_select "form[action=?][method=?]", playcelet_path(@playcelet), "post" do

      assert_select "input#playcelet_color[name=?]", "playcelet[color]"

      assert_select "input#playcelet_playcelet_id[name=?]", "playcelet[playcelet_id]"
    end
  end
end
