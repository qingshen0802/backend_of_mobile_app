require 'rails_helper'

RSpec.describe "messages/show", :type => :view do
  before(:each) do
    @message = assign(:message, Message.create!(
      :playcelet_id => "Playcelet",
      :app_id => "App",
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Playcelet/)
    expect(rendered).to match(/App/)
    expect(rendered).to match(/Type/)
  end
end
