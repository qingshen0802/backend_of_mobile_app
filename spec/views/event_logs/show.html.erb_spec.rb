require 'rails_helper'

RSpec.describe "event_logs/show", :type => :view do
  before(:each) do
    @event_log = assign(:event_log, EventLog.create!(
      :event_type => "Event Type",
      :record_type => "",
      :record_id => 1,
      :initiator_type => "Initiator Type",
      :initiator_id => 2,
      :family1_id => 3,
      :family2_id => 4,
      :parent1_id => 5,
      :parent2_id => 6,
      :child1_id => 7,
      :child2_id => 8
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Event Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Initiator Type/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/7/)
    expect(rendered).to match(/8/)
  end
end
