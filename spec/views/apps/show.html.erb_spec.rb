require 'rails_helper'

RSpec.describe "apps/show", :type => :view do
  before(:each) do
    @app = assign(:app, App.create!(
      :name => "Name",
      :version => "Version"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Version/)
  end
end
