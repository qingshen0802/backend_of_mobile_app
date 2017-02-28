class AddDurationEndTimeToMessages < ActiveRecord::Migration
  def change
  	add_column :messages, :duration, :integer
  	add_column :messages, :end_time, :datetime
  end
end
