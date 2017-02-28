require 'rails_helper'

RSpec.describe "supervisors/edit", :type => :view do
  before(:each) do
    @supervisor = assign(:supervisor, Supervisor.create!(
      :first_name => "MyString",
      :last_name => "MyString",
      :family_id => 1,
      :application_id => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit supervisor form" do
    render

    assert_select "form[action=?][method=?]", supervisor_path(@supervisor), "post" do

      assert_select "input#supervisor_first_name[name=?]", "supervisor[first_name]"

      assert_select "input#supervisor_last_name[name=?]", "supervisor[last_name]"

      assert_select "input#supervisor_family_id[name=?]", "supervisor[family_id]"

      assert_select "input#supervisor_application_id[name=?]", "supervisor[application_id]"

      assert_select "input#supervisor_user_id[name=?]", "supervisor[user_id]"
    end
  end
end
