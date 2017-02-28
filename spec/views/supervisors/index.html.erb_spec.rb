require 'rails_helper'

RSpec.describe "supervisors/index", :type => :view do
  before(:each) do
    assign(:supervisors, [
      Supervisor.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :family_id => 1,
        :application_id => "Application",
        :user_id => 2
      ),
      Supervisor.create!(
        :first_name => "First Name",
        :last_name => "Last Name",
        :family_id => 1,
        :application_id => "Application",
        :user_id => 2
      )
    ])
  end

  it "renders a list of supervisors" do
    render
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Application".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
