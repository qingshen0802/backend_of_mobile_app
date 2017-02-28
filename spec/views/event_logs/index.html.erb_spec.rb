require 'rails_helper'

RSpec.describe "event_logs/index", :type => :view do
  before(:each) do
    assign(:event_logs, [
      EventLog.create!(
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
      ),
      EventLog.create!(
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
      )
    ])
  end

  it "renders a list of event_logs" do
    render
    assert_select "tr>td", :text => "Event Type".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Initiator Type".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
    assert_select "tr>td", :text => 6.to_s, :count => 2
    assert_select "tr>td", :text => 7.to_s, :count => 2
    assert_select "tr>td", :text => 8.to_s, :count => 2
  end
end
