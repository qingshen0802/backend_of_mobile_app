require 'rails_helper'

RSpec.describe "infos/show", :type => :view do
  before(:each) do
    @info = assign(:info, Info.create!(
      :message_type => "Message Type",
      :app_id => 1,
      :playcelet_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Message Type/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
