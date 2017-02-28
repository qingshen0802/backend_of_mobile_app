require 'rails_helper'

RSpec.describe "event_logs/new", :type => :view do
  before(:each) do
    assign(:event_log, EventLog.new(
      :event_type => "MyString",
      :record_type => "",
      :record_id => 1,
      :initiator_type => "MyString",
      :initiator_id => 1,
      :family1_id => 1,
      :family2_id => 1,
      :parent1_id => 1,
      :parent2_id => 1,
      :child1_id => 1,
      :child2_id => 1
    ))
  end

  it "renders new event_log form" do
    render

    assert_select "form[action=?][method=?]", event_logs_path, "post" do

      assert_select "input#event_log_event_type[name=?]", "event_log[event_type]"

      assert_select "input#event_log_record_type[name=?]", "event_log[record_type]"

      assert_select "input#event_log_record_id[name=?]", "event_log[record_id]"

      assert_select "input#event_log_initiator_type[name=?]", "event_log[initiator_type]"

      assert_select "input#event_log_initiator_id[name=?]", "event_log[initiator_id]"

      assert_select "input#event_log_family1_id[name=?]", "event_log[family1_id]"

      assert_select "input#event_log_family2_id[name=?]", "event_log[family2_id]"

      assert_select "input#event_log_parent1_id[name=?]", "event_log[parent1_id]"

      assert_select "input#event_log_parent2_id[name=?]", "event_log[parent2_id]"

      assert_select "input#event_log_child1_id[name=?]", "event_log[child1_id]"

      assert_select "input#event_log_child2_id[name=?]", "event_log[child2_id]"
    end
  end
end
