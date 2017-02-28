require 'rails_helper'

RSpec.describe "supervisors/show", :type => :view do
  before(:each) do
    @supervisor = assign(:supervisor, Supervisor.create!(
      :first_name => "First Name",
      :last_name => "Last Name",
      :family_id => 1,
      :application_id => "Application",
      :user_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Application/)
    expect(rendered).to match(/2/)
  end
end
