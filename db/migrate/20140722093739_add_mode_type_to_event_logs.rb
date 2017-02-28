class AddModeTypeToEventLogs < ActiveRecord::Migration
  def change
  	add_column :event_logs, :mode_type, :string
  	add_index :event_logs, :mode_type
  end
end
