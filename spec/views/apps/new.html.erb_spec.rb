require 'rails_helper'

RSpec.describe "apps/new", :type => :view do
  before(:each) do
    assign(:app, App.new(
      :name => "MyString",
      :version => "MyString"
    ))
  end

  it "renders new app form" do
    render

    assert_select "form[action=?][method=?]", apps_path, "post" do

      assert_select "input#app_name[name=?]", "app[name]"

      assert_select "input#app_version[name=?]", "app[version]"
    end
  end
end
