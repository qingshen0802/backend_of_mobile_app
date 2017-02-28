class AddDetailsToEventLogs < ActiveRecord::Migration
  def change
  	add_column :event_logs, :details, :string
  end
end
